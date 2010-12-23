Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0LWPKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:10:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0LWPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:10:15 -0500
Message-ID: <4D13664C.3020500@redhat.com>
Date: Thu, 23 Dec 2010 16:10:04 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix accounting bug on cross partition merges
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com> <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com>
In-Reply-To: <4D0BB4A1.8080305@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 08:06 PM, Jens Axboe wrote:
> On 2010-12-17 14:42, Jerome Marchand wrote:
>>
>> /proc/diskstats would display a strange output as follows.
> 
> [snip]
> 
> This looks a lot better! One comment:
> 
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 4ce953f..064921d 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -64,13 +64,16 @@ static void drive_stat_acct(struct request *rq, int new_io)
>>  		return;
>>  
>>  	cpu = part_stat_lock();
>> -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>  
>> -	if (!new_io)
>> +	if (!new_io) {
>> +		part = rq->part;
>>  		part_stat_inc(cpu, part, merges[rw]);
>> -	else {
>> +	} else {
>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>  		part_round_stats(cpu, part);
>>  		part_inc_in_flight(part, rw);
>> +		kref_get(&part->ref);
>> +		rq->part = part;
>>  	}
>>  
>>  	part_stat_unlock();
> 
> I don't think this is completely safe. The rcu lock is held due to the
> part_stat_lock(), but that only prevents the __delete_partition()
> callback from happening. Lets say you have this:
> 
> CPU0                                         CPU1
> part = disk_map_sector_rcu()
>                                              kref_put(part); <- now 0

A kref_get(part) happens here, or am I missing something?
If we use an atomic kref_test_and_get() function, which only increment the
refcount if it's not zero, we would be safe. If kref_test_and_get() fails,
we can cache rq->rq_disk->part0 instead. See my drafty patch below.

> part_stat_unlock()
>                                              __delete_partition();
>                                              ...
>                                              delete_partition_rcu_cb();
> merge, or endio, boom
> 
> Now rq has ->part pointing to freed memory, later merges or end
> accounting will touch freed memory.
> 
> I think we can fix this by just having delete_partition_rcu_rb() check
> the reference count and return if non-zero. Since someone holds a
> reference to the table, they will drop it and we'll re-schedule the rcu
> callback.
> 
> 


---

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..72d12d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,13 +64,21 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		return;
 
 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 
-	if (!new_io)
+	if (!new_io) {
+		part = rq->part;
 		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
+		if(part->partno && !kref_test_and_get(&part->ref))
+			/*
+			 * The partition is already being removed,
+			 * the request will be accounted on the disk only
+			 */
+			part = &rq->rq_disk->part0;
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
+		rq->part = part;
 	}
 
 	part_stat_unlock();
@@ -128,6 +136,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
+	rq->part = NULL;
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1776,7 +1785,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1796,13 +1805,15 @@ static void blk_account_io_done(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rw);
 
+		if (part->partno)
+			kref_put(&part->ref, __delete_partition);
 		part_stat_unlock();
 	}
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 77b7c26..3334578 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -351,11 +351,13 @@ static void blk_account_io_merge(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;
 
 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rq_data_dir(req));
 
+		if (part->partno)
+			kref_put(&part->ref, __delete_partition);
 		part_stat_unlock();
 	}
 }
diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..0c55eae 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1192,6 +1192,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			return NULL;
 		}
 		disk->part_tbl->part[0] = &disk->part0;
+		kref_init(&disk->part0.ref);
 
 		disk->minors = minors;
 		rand_initialize_disk(disk);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 0a8b0ad..0123717 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -372,6 +372,13 @@ static void delete_partition_rcu_cb(struct rcu_head *head)
 	put_device(part_to_dev(part));
 }
 
+void __delete_partition(struct kref *ref)
+{
+	struct hd_struct *part = container_of(ref, struct hd_struct, ref);
+
+	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
+}
+
 void delete_partition(struct gendisk *disk, int partno)
 {
 	struct disk_part_tbl *ptbl = disk->part_tbl;
@@ -390,7 +397,7 @@ void delete_partition(struct gendisk *disk, int partno)
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
-	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
+	kref_put(&part->ref, __delete_partition);
 }
 
 static ssize_t whole_disk_show(struct device *dev,
@@ -489,6 +496,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	if (!dev_get_uevent_suppress(ddev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
+	kref_init(&p->ref);
 	return p;
 
 out_free_info:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aae86fd..482a7fd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -115,6 +115,7 @@ struct request {
 	void *elevator_private3;
 
 	struct gendisk *rq_disk;
+	struct hd_struct *part;
 	unsigned long start_time;
 #ifdef CONFIG_BLK_CGROUP
 	unsigned long long start_time_ns;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7a7b9c1..2ba2792 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -116,6 +116,7 @@ struct hd_struct {
 	struct disk_stats dkstats;
 #endif
 	struct rcu_head rcu_head;
+	struct kref ref;
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -583,6 +584,7 @@ extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     sector_t len, int flags,
 						     struct partition_meta_info
 						       *info);
+extern void __delete_partition(struct kref *ref);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 6cc38fc..90b9e44 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -23,6 +23,7 @@ struct kref {
 
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
+int kref_test_and_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
 #endif /* _KREF_H_ */
diff --git a/lib/kref.c b/lib/kref.c
index d3d227a..5f663b9 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -37,6 +37,22 @@ void kref_get(struct kref *kref)
 }
 
 /**
+ * kref_test_and_get - increment refcount for object only if refcount is not
+ * zero.
+ * @kref: object.
+ *
+ * Return non-zero if the refcount was incremented, 0 otherwise
+ */
+int kref_test_and_get(struct kref *kref)
+{
+	int ret;
+	smp_mb__before_atomic_inc();
+	ret = atomic_inc_not_zero(&kref->refcount);
+	smp_mb__after_atomic_inc();
+	return ret;
+}
+
+/**
  * kref_put - decrement refcount for object.
  * @kref: object.
  * @release: pointer to the function that will clean up the object when the
