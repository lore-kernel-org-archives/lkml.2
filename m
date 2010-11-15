Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0KOHEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:04:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32963 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab0KOHEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qyVjj/Jb9Vb01t0Qy8CHNaNMoGbLUYhUi3vN1caMSeQoqmxlyye/XJ1HoF99Od7gGQ
         4atyvHBippYZJvzMjZvKfKXP4gj2sjqKYwtWFzWJUB3vSHXjjskTHAr9DTrkCrZMfWrt
         uV+wvmH47G874bIZ38i0sLh1Jx+VbezFQfvgw=
Date: Sun, 14 Nov 2010 23:04:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Message-ID: <20101115070436.GC14442@core.coreip.homeip.net>
References: <20101022185437.GA9103@kroah.com>
 <4CD8566D.1020202@vlnb.net>
 <20101109002829.GA22633@kroah.com>
 <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com>
 <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com>
 <4CDC56F9.9040601@vlnb.net>
 <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDEC8D2.8080101@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 08:20:18PM +0300, Vladislav Bolkhovitin wrote:
> Dmitry Torokhov, on 11/12/2010 04:23 AM wrote:
> >>> This put might not be the last put on the object, IOs in flight
> >>> and/or open files might have extra reference on the object.
> >>> We release our initial ref, and below wait for all operations
> >>> to complete. (Is there a matter of timeout like files not closing?)
> >>
> >> This is the last internal put. All other references are from outsiders.
> >> So, we are waiting for all them to put before we go on.
> >>
> > 
> > The question is why do you need to wait here? I presume it is module
> > unloading path, but then it is quite bad - you can easily wedge your
> > subsystem if you make something to take a reference to your kobject
> > while module is ytying to be unloaded. Back when sysfs attributes tied
> > kobjects the easiest thing was to do:
> > 
> > 	rmmod <module> < / sys/devices/..../attribute
> > 
> > If you are done with the kobject - just proceed with what you were doing
> > and let it die its own peaceful death some time later. You just need to
> > make sure release code sticks around to free it and your subsystem core
> > can be tasked with this. Use module counter to prevent unloading of the
> > subsystem core until all kobjects belonging to the subsystem are
> > destroyed.
> 
> This is a very good question. During implementation I spent a lot of
> time working on it.
> 
> In fact, the first implementation was asynchronous similarly as you
> proposing, i.e. it just proceed with what you were doing and let it die
> its own peaceful death some time later. But soon the implementation was
> becoming so complicated, so it started getting out of control. For
> instance, some of the tasks to solve with this approach were:
> 
> 1. What to do if another SCST object is being created with the same name
> as supposed to be deleted, but not completely dead yet?

The same rules as with files - the object disappears from the
"directories" so no new users can get it but is not destroyed till last
reference is gone.

> 
> 2. What to do if a dieing object is found on some list and reference for
> is supposed to be taken? If the object deleted from the list before it
> marked dieing, i.e. the latest internal put() done, it made additional
> problems during deleting it after the latest external put done.

You delete the object from the list, then mark it as dead, notify users,
drop refcount. No new users will get it (as it is not on the list
anymore) and existing ones should notice that it is dead and stop using
it.

> 
> ...
> 
> So, I decided to reimplement it to be completely synchronous. SYSFS
> authors did really great job and thanks to the excellent internal SYSFS
> design and implementation it is absolutely safe. See:
> 
> [root@tgt ~]# modprobe scst
> [root@tgt ~]# cd /sys/kernel/scst_tgt/
> [root@tgt scst_tgt]# ls -l
> total 0
> drwxr-xr-x 4 root root    0 Nov 13 21:31 devices
> drwxr-xr-x 2 root root    0 Nov 13 21:31 handlers
> -r--r--r-- 1 root root 4096 Nov 13 21:30 last_sysfs_mgmt_res
> -rw-r--r-- 1 root root 4096 Nov 13 21:30 setup_id
> drwxr-xr-x 5 root root    0 Nov 13 21:31 sgv
> drwxr-xr-x 2 root root    0 Nov 13 21:31 targets
> -rw-r--r-- 1 root root 4096 Nov 13 21:30 threads
> -rw-r--r-- 1 root root 4096 Nov 13 21:30 trace_level
> -r--r--r-- 1 root root 4096 Nov 13 21:30 version
> [root@tgt scst_tgt]# cat version
> 2.1.0-pre1
> EXTRACHECKS
> DEBUG
> [root@tgt scst_tgt]# rmmod scst </sys/kernel/scst_tgt/version
> [root@tgt scst_tgt]# ls -l
> total 0
> [root@tgt scst_tgt]# pwd
> /sys/kernel/scst_tgt
> [root@tgt scst_tgt]# lsmod
> Module                  Size  Used by
> scsi_debug             65188  0
> w83627hf               22424  0
> hwmon_vid               2207  1 w83627hf
> adm1021                 6189  0
> binfmt_misc             6229  1
> xfs                   673142  1
> exportfs                3143  1 xfs
> dm_mirror              12069  0
> dm_region_hash          8703  1 dm_mirror
> dm_log                  8345  2 dm_mirror,dm_region_hash
> dm_mod                 63511  2 dm_mirror,dm_log
> pci_slot                3378  0
> hed                     1758  0
> floppy                 52718  0
> uhci_hcd               21459  0
> sg                     25181  0
> e1000                 128475  0
> i2c_i801                8756  0
> pcspkr                  1442  0
> i2c_core               22319  2 adm1021,i2c_i801
> e7xxx_edac              3463  0
> parport_pc             25439  0
> parport                29682  1 parport_pc
> 
> Everything works fine.
> 
> This is because SYSFS doesn't hold references for the corresponding
> kobjects for every open file handle. It holds references only when
> show() and store() functions called. So, everything is under control and
> a malicious user can do nothing to hold a reference forever.

Right, Tejun plugged this particular (and very annoying) attributes
behavior, but that does not mean that this is the only way kobject's
reference might be pinned.

-- 
Dmitry
