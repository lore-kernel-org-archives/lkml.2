Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2D3Nyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab2D3Nyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:54:50 -0400
Message-ID: <4F9E9958.6010606@redhat.com>
Date: Mon, 30 Apr 2012 10:53:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?Niklas_S=F6d?= =?ISO-8859-1?Q?erlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ABCEC.9090807@redhat.com> <20120428090523.GD26065@aftab.osrc.amd.com> <4F9D46F8.1020104@redhat.com> <20120430081513.GD8182@aftab.osrc.amd.com> <4F9E7059.5070804@redhat.com> <20120430111126.GD9303@aftab.osrc.amd.com> <4F9E7B45.8010908@redhat.com> <20120430123819.GF9303@aftab.osrc.amd.com> <4F9E8CFE.1040801@redhat.com>
In-Reply-To: <4F9E8CFE.1040801@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 10:00, Mauro Carvalho Chehab escreveu:
> Em 30-04-2012 09:38, Borislav Petkov escreveu:
>> On Mon, Apr 30, 2012 at 08:45:09AM -0300, Mauro Carvalho Chehab wrote:
>>> Em 30-04-2012 08:11, Borislav Petkov escreveu:
>>>> On Mon, Apr 30, 2012 at 07:58:33AM -0300, Mauro Carvalho Chehab wrote:
> 
>>>> This way it says "initializing 12 dimms" and the user thinks there are
>>>> 12 DIMMs on his system where this might not be true.
>>>
>>>
>>> I'm OK to remove the "initializing 12 dimms" message. It doesn't add anything
>>> new.
>>>
>>> With regards do the other messages, if the debug messages are not clear, 
>>> then let's fix them, instead of removing. What if we print, instead,
>>> on a message like:
>>>
>>> 	"row 1, chan 1 will represent dimm5 (1:2:0) if not empty"
>>
>> How about the following instead: the specific driver calls
>> edac_mc_alloc(), it gets the allocated dimm array in mci->dimms
>> _without_ dumping each dimm%d line. Then, each driver figures out which
>> subset of that dimms array actually has populated slots and prints only
>> the populated rank/slot/...
>>
>> This information is much more valuable than saying how many _possible_
>> slots the edac core has allocated.
>>
>> Then, each driver can decide whether it makes sense to dump that info or
>> not.
> 
> No, that would add extra complexity at the drivers level just due to debug
> messages. I think that the better is to move this printk to the debug-specific
> routine that is called only when the dimm is filled (edac_mc_dump_dimm).
> 
> With this cange, the message will be printed only for the filled dimms.
> 
> This is a cleanup patch, so I'll write it, together with the change that
> will get rid of the loop that uses KERN_CONT. It will use a function added
> by a latter patch at edac_mc_sysfs so it can't be merged on this patch
> anyway.

The following patch dos the debug cleanup. I'll add at the end of my tree.

Regards,
Mauro.


From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 30 Apr 2012 10:24:43 -0300
Subject: [PATCH] edac_mc: Cleanup per-dimm_info debug messages

The edac_mc_alloc() routine allocates one dimm_info device for all
possible memories, including the non-filled ones. The debug messages
there are somewhat confusing. So, cleans them, by moving the code
that prints the memory location to edac_mc, and using it on both
edac_mc_sysfs and edac_mc.

After this patch, a dimm-based memory controller will print the debug
info as:

[  728.430828] EDAC DEBUG: edac_mc_dump_dimm: 	dimm2: channel 0 slot 2 mapped as virtual row 0, chan 2
[  728.430834] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->label = 'mc#0channel#0slot#2'
[  728.430839] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0
[  728.430846] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->grain = 0
[  728.430850] EDAC DEBUG: edac_mc_dump_dimm: 	dimm->nr_pages = 0x0

(a rank-based memory controller would print, instead, "rank2"
 on the above debug info)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d8278b3..1bc2843 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -40,6 +40,25 @@
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+			         int len)
+{
+	struct mem_ctl_info *mci = dimm->mci;
+	int i, n, count = 0;
+	char *p = buf;
+
+	for (i = 0; i < mci->n_layers; i++) {
+		n = snprintf(p, len, "%s %d ",
+			      edac_layer_name[mci->layers[i].type],
+			      dimm->location[i]);
+		p += n;
+		len -= n;
+		count += n;
+	}
+
+	return count;
+}
+
 #ifdef CONFIG_EDAC_DEBUG
 
 static void edac_mc_dump_channel(struct rank_info *chan)
@@ -50,20 +69,18 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 	debugf4("\tchannel->dimm = %p\n", chan->dimm);
 }
 
-static void edac_mc_dump_dimm(struct dimm_info *dimm)
+static void edac_mc_dump_dimm(struct dimm_info *dimm, int number)
 {
-	int i;
+	char location[80];
+
+	edac_dimm_info_location(dimm, location, sizeof(location));
 
 	debugf4("\tdimm = %p\n", dimm);
+	debugf4("\t%s%i: %smapped as virtual row %d, chan %d\n",
+		dimm->mci->mem_is_per_rank ? "rank" : "dimm",
+		number, location, dimm->csrow, dimm->cschannel);
 	debugf4("\tdimm->label = '%s'\n", dimm->label);
 	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
-	debugf4("\tdimm location ");
-	for (i = 0; i < dimm->mci->n_layers; i++) {
-		printk(KERN_CONT "%d", dimm->location[i]);
-		if (i < dimm->mci->n_layers - 1)
-			printk(KERN_CONT ".");
-	}
-	printk(KERN_CONT "\n");
 	debugf4("\tdimm->grain = %d\n", dimm->grain);
 	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
@@ -337,8 +354,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	debugf4("initializing %d %s\n", tot_dimms,
-		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = mci->csrows[row]->channels[chn];
 		off = EDAC_DIMM_OFF(layer, n_layers, pos[0], pos[1], pos[2]);
@@ -351,10 +366,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		debugf2("%d: %s%i (%d:%d:%d): row %d, chan %d\n", i,
-			per_rank ? "rank" : "dimm", off,
-			pos[0], pos[1], pos[2], row, chn);
-
 		/*
 		 * Copy DIMM location and initialize the memory location
 		 */
@@ -730,7 +741,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 				edac_mc_dump_channel(mci->csrows[i]->channels[j]);
 		}
 		for (i = 0; i < mci->tot_dimms; i++)
-			edac_mc_dump_dimm(mci->dimms[i]);
+			edac_mc_dump_dimm(mci->dimms[i], i);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 8f96c49..e3e9e75 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -488,13 +488,7 @@ static ssize_t dimmdev_location_show(struct device *dev,
 	int i;
 	char *p = data;
 
-	for (i = 0; i < mci->n_layers; i++) {
-		p += sprintf(p, "%s %d ",
-			     edac_layer_name[mci->layers[i].type],
-			     dimm->location[i]);
-	}
-
-	return p - data;
+	return edac_dimm_info_location(dimm, data, PAGE_SIZE);
 }
 
 static ssize_t dimmdev_label_show(struct device *dev,
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 1af1367..de92756 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -34,6 +34,9 @@ extern int edac_mc_get_panic_on_ue(void);
 extern int edac_get_poll_msec(void);
 extern int edac_mc_get_poll_msec(void);
 
+unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
+				 int len);
+
 	/* on edac_device.c */
 extern int edac_device_register_sysfs_main_kobj(
 				struct edac_device_ctl_info *edac_dev);
