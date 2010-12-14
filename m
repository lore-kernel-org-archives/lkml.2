Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0LNGJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 01:09:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64287 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab0LNGJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 01:09:11 -0500
Message-ID: <4D070A1D.4060904@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 14:09:33 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling
 with CFQ queue and group at the same level
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com> <4D057A9D.1090809@cn.fujitsu.com> <20101214034914.GA8713@redhat.com>
In-Reply-To: <20101214034914.GA8713@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 14:09:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 14:09:10,
	Serialize complete at 2010-12-14 14:09:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>> -static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
>> +static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>  {
>> -	struct cfq_rb_root *st = &cfqd->grp_service_tree;
>> -	struct cfq_group *cfqg;
>> -	struct cfq_entity *cfqe;
>> +	struct cfq_rb_root *st;
>> +	unsigned count;
>>  
>> -	if (RB_EMPTY_ROOT(&st->rb))
>> -		return NULL;
>> -	cfqe = cfq_rb_first_entity(st);
>> -	cfqg = cfqg_of_entity(cfqe);
>> -	BUG_ON(!cfqg);
>> -	update_min_vdisktime(st);
>> -	return cfqg;
>> +	if (!cfqg) {
>> +		cfqd->serving_prio = IDLE_WORKLOAD;
>> +		cfqd->workload_expires = jiffies + 1;
>> +		return;
>> +	}
> 
> I am wondering where do we use above code. Do we ever call
> choose_service_tree() with cfqg == NULL? Can't seem to figure out by
> looking at the code.
> 

Vivek,

This piece of code comes from original CFQ code. Think more about it, this
piece of code seems redundant. When cfq_choose_cfqg() is called in select_queue(),
there must be at least one backlogged CFQ queue waiting for dispatching, hence
there must be at least one backlogged CFQ group on service tree. So we never call
choose_service_tree() with cfqg == NULL.
I'd like to post a seperate patch to get rid of this piece.

Thanks,
Gui
