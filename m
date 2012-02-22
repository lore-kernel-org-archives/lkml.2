Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2BVRyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:54:12 -0500
Received: from mx2.netapp.com ([216.240.18.37]:23216 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVRyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:54:07 -0500
X-IronPort-AV: E=Sophos;i="4.73,465,1325491200"; 
   d="scan'208";a="627705030"
From: "Moger, Babu" <Babu.Moger@netapp.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Subject: RE: [PATCH] scsi_dh_rdac: Fix for unbalanced reference count
Thread-Topic: [PATCH] scsi_dh_rdac: Fix for unbalanced reference count
Thread-Index: AczhvmCiRoDulGQxT6qRtOagKMBb+gAZ6zeAA9kbGeA=
Date: Wed, 22 Feb 2012 17:53:43 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0181ED@SACEXCMBX02-PRD.hq.netapp.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B01032D@SACEXCMBX02-PRD.hq.netapp.com>
 <1328211835.2213.27.camel@chandra-lucid.austin.ibm.com>
In-Reply-To: <1328211835.2213.27.camel@chandra-lucid.austin.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 22 Feb 2012 17:53:44.0908 (UTC) FILETIME=[EBB350C0:01CCF18A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1MHsSAl026198

James, Can you please pick this up for the next update.

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Thursday, February 02, 2012 1:44 PM
> To: Moger, Babu
> Cc: linux-kernel@vger.kernel.org; device-mapper development; Mike
> Snitzer
> Subject: Re: [PATCH] scsi_dh_rdac: Fix for unbalanced reference count
> 
> Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> On Thu, 2012-02-02 at 15:21 +0000, Moger, Babu wrote:
> > Resubmitting it again(Probably last one had some format issues).
> >
> > This patch fixes an unbalanced refcount issue.
> >
> > Elevating the lock for both kref_put and also for controller node
> deletion.
> > Previously, controller deletion was protected but the not the
> kref_put. This was causing
> > the other thread to pick up the controller structure which was
> already kref'd zero.
> >
> > This was causing the following BUG_ON and also sometimes panic.
> >
> > WARNING: at lib/kref.c:43 kref_get+0x2d/0x30() (Not tainted)
> > Hardware name: IBM System x3655 -[7985AC1]-
> > Modules linked in: fuse scsi_dh_rdac autofs4 nfs lockd fscache
> nfs_acl
> > auth_rpcgss sunrpc 8021q garp stp llc ipv6 ib_srp(U)
> scsi_transport_srp
> > scsi_tgt ib_cm(U) ib_sa(U) ib_uverbs(U) ib_umad(U) mlx4_ib(U)
> mlx4_core(U)
> > ib_mthca(U) ib_mad(U) ib_core(U) dm_mirror dm_region_hash dm_log
> dm_round_robin
> > dm_multipath uinput bnx2 ses enclosure sg ibmpex ibmaem
> ipmi_msghandler
> > serio_raw k8temp hwmon amd64_edac_mod edac_core edac_mce_amd shpchp
> i2c_piix4
> > ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif sata_svw pata_acpi
> ata_generic
> > pata_serverworks aacraid radeon ttm drm_kms_helper drm i2c_algo_bit
> i2c_core
> > dm_mod [last unloaded: freq_table]
> > Pid: 13735, comm: srp_daemon Not tainted 2.6.32-71.el6.x86_64 #1
> > Call Trace:
> > [<ffffffff8106b857>] warn_slowpath_common+0x87/0xc0
> > [<ffffffff8106b8aa>] warn_slowpath_null+0x1a/0x20
> > [<ffffffff8125c39d>] kref_get+0x2d/0x30
> > [<ffffffffa01b4029>] rdac_bus_attach+0x459/0x580 [scsi_dh_rdac]
> > [<ffffffff8135232a>] scsi_dh_handler_attach+0x2a/0x80
> > [<ffffffff81352c7b>] scsi_dh_notifier+0x9b/0xa0
> > [<ffffffff814cd7a5>] notifier_call_chain+0x55/0x80
> > [<ffffffff8109711a>] __blocking_notifier_call_chain+0x5a/0x80
> > [<ffffffff81097156>] blocking_notifier_call_chain+0x16/0x20
> > [<ffffffff8132bec5>] device_add+0x515/0x640
> > [<ffffffff813329e4>] ? attribute_container_device_trigger+0xc4/0xe0
> > [<ffffffff8134f659>] scsi_sysfs_add_sdev+0x89/0x2c0
> > [<ffffffff8134d096>] scsi_probe_and_add_lun+0xea6/0xed0
> > [<ffffffff8134beb2>] ? scsi_alloc_target+0x292/0x2d0
> > [<ffffffff8134d1e1>] __scsi_scan_target+0x121/0x750
> > [<ffffffff811df806>] ? sysfs_create_file+0x26/0x30
> > [<ffffffff8132b759>] ? device_create_file+0x19/0x20
> > [<ffffffff81332838>] ? attribute_container_add_attrs+0x78/0x90
> > [<ffffffff814b008c>] ? klist_next+0x4c/0xf0
> > [<ffffffff81332e30>] ? transport_configure+0x0/0x20
> > [<ffffffff813329e4>] ? attribute_container_device_trigger+0xc4/0xe0
> > [<ffffffff8134df40>] scsi_scan_target+0xd0/0xe0
> > [<ffffffffa02f053a>] srp_create_target+0x75a/0x890 [ib_srp]
> > [<ffffffff8132a130>] dev_attr_store+0x20/0x30
> > [<ffffffff811df145>] sysfs_write_file+0xe5/0x170
> > [<ffffffff8116c818>] vfs_write+0xb8/0x1a0
> > [<ffffffff810d40a2>] ? audit_syscall_entry+0x272/0x2a0
> > [<ffffffff8116d251>] sys_write+0x51/0x90
> > [<ffffffff81013172>] system_call_fastpath+0x16/0x1b
> >
> >
> > Signed-off-by: Babu Moger <babu.moger@netapp.com>
> > Acked-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> > --- linux-3.3-rc1-new/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 	2012-01-19 17:04:48.000000000 -0600
> > +++ linux-3.3-rc1-new/drivers/scsi/device_handler/scsi_dh_rdac.c
> 	2012-02-01 10:50:31.000000000 -0600
> > @@ -364,10 +364,7 @@ static void release_controller(struct kr
> >  	struct rdac_controller *ctlr;
> >  	ctlr = container_of(kref, struct rdac_controller, kref);
> >
> > -	flush_workqueue(kmpath_rdacd);
> > -	spin_lock(&list_lock);
> >  	list_del(&ctlr->node);
> > -	spin_unlock(&list_lock);
> >  	kfree(ctlr);
> >  }
> >
> > @@ -376,20 +373,17 @@ static struct rdac_controller *get_contr
> >  {
> >  	struct rdac_controller *ctlr, *tmp;
> >
> > -	spin_lock(&list_lock);
> > -
> >  	list_for_each_entry(tmp, &ctlr_list, node) {
> >  		if ((memcmp(tmp->array_id, array_id, UNIQUE_ID_LEN) == 0)
> &&
> >  			  (tmp->index == index) &&
> >  			  (tmp->host == sdev->host)) {
> >  			kref_get(&tmp->kref);
> > -			spin_unlock(&list_lock);
> >  			return tmp;
> >  		}
> >  	}
> >  	ctlr = kmalloc(sizeof(*ctlr), GFP_ATOMIC);
> >  	if (!ctlr)
> > -		goto done;
> > +		return NULL;
> >
> >  	/* initialize fields of controller */
> >  	memcpy(ctlr->array_id, array_id, UNIQUE_ID_LEN);
> > @@ -405,8 +399,7 @@ static struct rdac_controller *get_contr
> >  	INIT_WORK(&ctlr->ms_work, send_mode_select);
> >  	INIT_LIST_HEAD(&ctlr->ms_head);
> >  	list_add(&ctlr->node, &ctlr_list);
> > -done:
> > -	spin_unlock(&list_lock);
> > +
> >  	return ctlr;
> >  }
> >
> > @@ -517,9 +510,12 @@ static int initialize_controller(struct
> >  			index = 0;
> >  		else
> >  			index = 1;
> > +
> > +		spin_lock(&list_lock);
> >  		h->ctlr = get_controller(index, array_name, array_id,
> sdev);
> >  		if (!h->ctlr)
> >  			err = SCSI_DH_RES_TEMP_UNAVAIL;
> > +		spin_unlock(&list_lock);
> >  	}
> >  	return err;
> >  }
> > @@ -906,7 +902,9 @@ static int rdac_bus_attach(struct scsi_d
> >  	return 0;
> >
> >  clean_ctlr:
> > +	spin_lock(&list_lock);
> >  	kref_put(&h->ctlr->kref, release_controller);
> > +	spin_unlock(&list_lock);
> >
> >  failed:
> >  	kfree(scsi_dh_data);
> > @@ -921,14 +919,19 @@ static void rdac_bus_detach( struct scsi
> >  	struct rdac_dh_data *h;
> >  	unsigned long flags;
> >
> > -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> >  	scsi_dh_data = sdev->scsi_dh_data;
> > +	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> > +	if (h->ctlr && h->ctlr->ms_queued)
> > +		flush_workqueue(kmpath_rdacd);
> > +
> > +	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> >  	sdev->scsi_dh_data = NULL;
> >  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> >
> > -	h = (struct rdac_dh_data *) scsi_dh_data->buf;
> > +	spin_lock(&list_lock);
> >  	if (h->ctlr)
> >  		kref_put(&h->ctlr->kref, release_controller);
> > +	spin_unlock(&list_lock);
> >  	kfree(scsi_dh_data);
> >  	module_put(THIS_MODULE);
> >  	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", RDAC_NAME);
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
