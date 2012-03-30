Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521Ab2C3Rex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab2C3Res (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:34:48 -0400
Message-ID: <4F75EEB3.2090209@redhat.com>
Date: Fri, 30 Mar 2012 14:34:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Greg K H <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com> <1333040821-6253-2-git-send-email-mchehab@redhat.com> <20120329220300.GA16491@kroah.com> <4F74EDEC.5020804@redhat.com> <20120329234037.GA16094@kroah.com> <4F7516B3.8070505@redhat.com> <20120330153152.GD18488@kroah.com>
In-Reply-To: <20120330153152.GD18488@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-03-2012 12:31, Greg K H escreveu:
> On Thu, Mar 29, 2012 at 11:13:07PM -0300, Mauro Carvalho Chehab wrote:
>> Em 29-03-2012 20:40, Greg K H escreveu:
>>> On Thu, Mar 29, 2012 at 08:19:08PM -0300, Mauro Carvalho Chehab wrote:
>>>>> Sweet, as per the documentation in the Documentation/kobjects.txt file,
>>>>> I get to publically mock you for thinking you are smarter than the
>>>>> kernel and this is an acceptable way to "outwhit" the driver core from
>>>>> spitting errors at you when the kobject is released.
>>>>
>>>> There's nothing there to free: all EDAC structures are allocated once
>>>> (see edac_mc_alloc() and edac_align_ptr() logic, at drivers/edac/edac_mc.c).
>>>>
>>>> Even the struct device for all csrows/channels/mcu is done on a single alloc
>>>> there. Trying to free it earlier would cause a segfault.
>>>
>>> That's wrong then, these are multiple struct devices, all with their own
>>> reference counts, you can't just treat them all as the same thing, even
>>> if it happens to line up with the module reference count.
>>>
>>>> I didn't wrote that logic, nor I was tempted to change it: as this subsystem 
>>>> is focused on memory error detection, having every data structure used there
>>>> on a single page helps to minimize the probability of having an error at the 
>>>> memory used to store the EDAC data.
>>>
>>> Possibly, but again, you have multiple reference counts, you can't just
>>> wave them off as being inconvenient.  Please read the documentation for
>>> more details why.
>>
>> This is there since the beginning. The current kobj's have this issue. Those
>> patchsets are not making it better or worse, as the EDAC csrow kobj's are
>> already there at the current approach: all of them are allocated together
>> with the mci kobj.
>>
>> On the other hand, I'm working on this patch series in order to correct a 
>> serious bug at the EDAC API almost all days during the last 2 months, as
>> nobody ever cared enough to address this serious issue.
> 
> That's because no one had touched the code.  Now that it has an active
> developer (i.e. you), it needs to be fixed.
> 
> Especially as the code you just added is wrong, and it's documented as
> wrong, and you know it is wrong as you are working around the kernel
> warnings by providing release functions that do nothing.
> 
> So please fix it, it's your code now.


Please check if this is the right thing to do. It does the EDAC core changes.

The real patch is a way more complex than that, as it required to change the 
struct mem_ctrl_info pointers to an array of array, instead of just an array,
with means that all drivers need to be changed. This patch is to be applied at
the end of the patch series.

Regards,
Mauro

[RFC] edac: dynamically allocate one *_info object each time, in order to meet struct device constraints

struct device doen't handle well kobjects that is allocated on
a single k*alloc() call.

PS.: this is just a small part of the patch: all edac drivers should
also change, as the internal API was modified.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d4f9336..b1ed014 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -205,14 +205,14 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	void *ptr;
 	struct mem_ctl_info *mci;
 	struct edac_mc_layer *lay;
-	struct csrow_info *csi, *csr;
-	struct rank_info *chi, *chp, *chan;
+	struct csrow_info *csr;
+	struct rank_info *chan;
 	struct dimm_info *dimm;
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt, *p;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
 	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
-	int i, j, n, len;
+	int i, j, n, len, off;
 	int row, chn;
 	bool per_rank = false;
 
@@ -243,9 +243,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	ptr = 0;
 	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
 	lay = edac_align_ptr(&ptr, sizeof(*lay), n_layers);
-	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
-	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_cschannels);
-	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
 	count = 1;
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
@@ -272,9 +269,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	lay = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)lay));
-	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
-	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
-	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
 	for (i = 0; i < n_layers; i++) {
 		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
 		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
@@ -283,8 +277,6 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 
 	/* setup index and various internal pointers */
 	mci->mc_idx = edac_index;
-	mci->csrows = csi;
-	mci->dimms  = dimm;
 	mci->tot_dimms = tot_dimms;
 	mci->pvt_info = pvt;
 	mci->n_layers = n_layers;
@@ -295,39 +287,55 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	mci->mem_is_per_rank = per_rank;
 
 	/*
-	 * Fills the csrow struct
+	 * Alocate and fill the csrow/channels structs
 	 */
+	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);
+	if (!mci->csrows)
+		goto error;
 	for (row = 0; row < tot_csrows; row++) {
-		csr = &csi[row];
+		csr = kzalloc(sizeof(**mci->csrows), GFP_KERNEL);
+		if (!csr)
+			goto error;
+		mci->csrows[row] = csr;
 		csr->csrow_idx = row;
 		csr->mci = mci;
 		csr->nr_channels = tot_cschannels;
-		chp = &chi[row * tot_cschannels];
-		csr->channels = chp;
+		csr->channels = kzalloc(sizeof(*csr->channels), GFP_KERNEL);
 
 		for (chn = 0; chn < tot_cschannels; chn++) {
-			chan = &chp[chn];
+			chan = kzalloc(sizeof(**csr->channels), GFP_KERNEL);
+			if (!chan)
+				goto error;
+			csr->channels[chn] = chan;
 			chan->chan_idx = chn;
 			chan->csrow = csr;
 		}
 	}
 
 	/*
-	 * Fills the dimm struct
+	 * Allocate and fill the dimm structs
 	 */
+	mci->dimms  = kzalloc(sizeof(*mci->dimms) * tot_dimms, GFP_KERNEL);
+	if (!mci->dimms)
+		goto error;
+
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
 	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
 		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
-		chan = &csi[row].channels[chn];
-		dimm = GET_POS(lay, mci->dimms, n_layers,
-			       pos[0], pos[1], pos[2]);
+		chan = mci->csrows[row]->channels[chn];
+		off = GET_OFFSET(lay, n_layers, pos[0], pos[1], pos[2]);
+		if (off < 0)
+			goto error;
+
+		dimm = kzalloc(sizeof(**mci->dimms), GFP_KERNEL);
+		mci->dimms[off] = dimm;
 		dimm->mci = mci;
 
-		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
-			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
+		debugf2("%s: %d: %s%i (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, per_rank ? "rank" : "dimm", off,
 			pos[0], pos[1], pos[2], row, chn);
 
 		/*
@@ -393,6 +401,25 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 
 	trace_hw_event_init("edac", (unsigned)edac_index);
 
+error:
+	if (mci->dimms) {
+		for (i = 0; i < tot_dimms; i++)
+			kfree(mci->dimms[i]);
+		kfree(mci->dimms);
+	}
+	if (mci->csrows) {
+		for (chn = 0; chn < tot_cschannels; chn++) {
+			csr = mci->csrows[chn];
+			if (csr) {
+				for (chn = 0; chn < tot_cschannels; chn++)
+					kfree(csr->channels[chn]);
+				kfree(csr);
+			}
+			kfree(mci->csrows[i]);
+		}
+		kfree(mci->csrows);
+	}
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -681,13 +708,12 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		for (i = 0; i < mci->num_csrows; i++) {
 			int j;
 
-			edac_mc_dump_csrow(&mci->csrows[i]);
-			for (j = 0; j < mci->csrows[i].nr_channels; j++)
-				edac_mc_dump_channel(&mci->csrows[i].
-						channels[j]);
+			edac_mc_dump_csrow(mci->csrows[i]);
+			for (j = 0; j < mci->csrows[i]->nr_channels; j++)
+				edac_mc_dump_channel(mci->csrows[i]->channels[j]);
 		}
 		for (i = 0; i < mci->tot_dimms; i++)
-			edac_mc_dump_dimm(&mci->dimms[i]);
+			edac_mc_dump_dimm(mci->dimms[i]);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
@@ -806,17 +832,17 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 /* FIXME - should return -1 */
 int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 {
-	struct csrow_info *csrows = mci->csrows;
+	struct csrow_info **csrows = mci->csrows;
 	int row, i, j, n;
 
 	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
 	row = -1;
 
 	for (i = 0; i < mci->num_csrows; i++) {
-		struct csrow_info *csrow = &csrows[i];
+		struct csrow_info *csrow = csrows[i];
 		n = 0;
 		for (j = 0; j < csrow->nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 			n += dimm->nr_pages;
 		}
 		if (n == 0)
@@ -969,7 +995,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	p = label;
 	*p = '\0';
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 
 		if (layer0 >= 0 && layer0 != dimm->location[0])
 			continue;
@@ -1022,13 +1048,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			strcpy(label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0) {
-				mci->csrows[row].ce_count++;
+				mci->csrows[row]->ce_count++;
 				if (chan >= 0)
-					mci->csrows[row].channels[chan].ce_count++;
+					mci->csrows[row]->channels[chan]->ce_count++;
 			}
 		} else
 			if (row >= 0)
-				mci->csrows[row].ue_count++;
+				mci->csrows[row]->ue_count++;
 	}
 
 	/* Fill the RAM location data */
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 3f2d62f..d9a33d9 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -82,7 +82,7 @@ module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
 		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
-static struct device mci_pdev;
+static struct device *mci_pdev;
 
 /*
  * various constants for Memory Controllers
@@ -181,7 +181,7 @@ static ssize_t csrow_size_show(struct device *dev,
 	u32 nr_pages = 0;
 
 	for (i = 0; i < csrow->nr_channels; i++)
-		nr_pages += csrow->channels[i].dimm->nr_pages;
+		nr_pages += csrow->channels[i]->dimm->nr_pages;
 	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
 }
 
@@ -190,7 +190,7 @@ static ssize_t csrow_mem_type_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", mem_types[csrow->channels[0].dimm->mtype]);
+	return sprintf(data, "%s\n", mem_types[csrow->channels[0]->dimm->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct device *dev,
@@ -198,7 +198,7 @@ static ssize_t csrow_dev_type_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", dev_types[csrow->channels[0].dimm->dtype]);
+	return sprintf(data, "%s\n", dev_types[csrow->channels[0]->dimm->dtype]);
 }
 
 static ssize_t csrow_edac_mode_show(struct device *dev,
@@ -207,7 +207,7 @@ static ssize_t csrow_edac_mode_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", edac_caps[csrow->channels[0].dimm->edac_mode]);
+	return sprintf(data, "%s\n", edac_caps[csrow->channels[0]->dimm->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
@@ -217,7 +217,7 @@ static ssize_t channel_dimm_label_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	/* if field has not been initialized, there is nothing to send */
 	if (!rank->dimm->label[0])
@@ -233,7 +233,7 @@ static ssize_t channel_dimm_label_store(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	ssize_t max_size = 0;
 
@@ -250,7 +250,7 @@ static ssize_t channel_ce_count_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 	unsigned chan = to_channel(mattr);
-	struct rank_info *rank = &csrow->channels[chan];
+	struct rank_info *rank = csrow->channels[chan];
 
 	return sprintf(data, "%u\n", rank->ce_count);
 }
@@ -283,9 +283,12 @@ static const struct attribute_group *csrow_attr_groups[] = {
 	NULL
 };
 
-static void csrow_attr_release(struct device *device)
+static void csrow_attr_release(struct device *dev)
 {
-	debugf1("Releasing csrow device %s\n", dev_name(device));
+	struct csrow_info *csrow = container_of(dev, struct csrow_info, dev);
+
+	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	kfree(csrow);
 }
 
 static struct device_type csrow_attr_type = {
@@ -352,7 +355,7 @@ static inline int nr_pages_per_csrow(struct csrow_info *csrow)
 	int chan, nr_pages = 0;
 
 	for (chan = 0; chan < csrow->nr_channels; chan++)
-		nr_pages += csrow->channels[chan].dimm->nr_pages;
+		nr_pages += csrow->channels[chan]->dimm->nr_pages;
 
 	return nr_pages;
 }
@@ -382,7 +385,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 
 	for (chan = 0; chan < csrow->nr_channels; chan++) {
 		/* Only expose populated DIMMs */
-		if (!csrow->channels[chan].dimm->nr_pages)
+		if (!csrow->channels[chan]->dimm->nr_pages)
 			continue;
 		err = device_create_file(&csrow->dev,
 					 dynamic_csrow_dimm_attr[chan]);
@@ -418,10 +421,10 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 
 	for (i = 0; i < mci->num_csrows; i++) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
-		err = edac_create_csrow_object(mci, &mci->csrows[i], i);
+		err = edac_create_csrow_object(mci, mci->csrows[i], i);
 		if (err < 0)
 			goto error;
 	}
@@ -429,18 +432,18 @@ static int edac_create_csrow_objects(struct mem_ctl_info *mci)
 
 error:
 	for (--i; i >= 0; i--) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
-			if (!csrow->channels[chan].dimm->nr_pages)
+			if (!csrow->channels[chan]->dimm->nr_pages)
 				continue;
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_dimm_attr[chan]);
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_ce_count_attr[chan]);
 		}
-		put_device(&mci->csrows[i].dev);
+		put_device(&mci->csrows[i]->dev);
 	}
 
 	return err;
@@ -452,11 +455,11 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 
 	for (i = mci->num_csrows - 1; i >= 0; i--) {
-		csrow = &mci->csrows[i];
+		csrow = mci->csrows[i];
 		if (!nr_pages_per_csrow(csrow))
 			continue;
 		for (chan = csrow->nr_channels - 1; chan >= 0; chan--) {
-			if (!csrow->channels[chan].dimm->nr_pages)
+			if (!csrow->channels[chan]->dimm->nr_pages)
 				continue;
 			debugf1("Removing csrow %d channel %d sysfs nodes\n",
 				i, chan);
@@ -465,8 +468,8 @@ static void edac_delete_csrow_objects(struct mem_ctl_info *mci)
 			device_remove_file(&csrow->dev,
 						dynamic_csrow_ce_count_attr[chan]);
 		}
-		put_device(&mci->csrows[i].dev);
-		device_del(&mci->csrows[i].dev);
+		put_device(&mci->csrows[i]->dev);
+		device_del(&mci->csrows[i]->dev);
 	}
 }
 #endif
@@ -585,9 +588,12 @@ static const struct attribute_group *dimm_attr_groups[] = {
 	NULL
 };
 
-static void dimm_attr_release(struct device *device)
+static void dimm_attr_release(struct device *dev)
 {
-	debugf1("Releasing dimm device %s\n", dev_name(device));
+	struct dimm_info *dimm = container_of(dev, struct dimm_info, dev);
+
+	debugf1("Releasing dimm device %s\n", dev_name(dev));
+	kfree(dimm);
 }
 
 static struct device_type dimm_attr_type = {
@@ -642,13 +648,13 @@ static ssize_t mci_reset_counters_store(struct device *dev,
 
 
 	for (row = 0; row < mci->num_csrows; row++) {
-		struct csrow_info *ri = &mci->csrows[row];
+		struct csrow_info *ri = mci->csrows[row];
 
 		ri->ue_count = 0;
 		ri->ce_count = 0;
 
 		for (chan = 0; chan < ri->nr_channels; chan++)
-			ri->channels[chan].ce_count = 0;
+			ri->channels[chan]->ce_count = 0;
 	}
 
 	cnt = 1;
@@ -782,10 +788,10 @@ static ssize_t mci_size_mb_show(struct device *dev,
 
 	for (total_pages = csrow_idx = 0; csrow_idx < mci->num_csrows;
 	     csrow_idx++) {
-		struct csrow_info *csrow = &mci->csrows[csrow_idx];
+		struct csrow_info *csrow = mci->csrows[csrow_idx];
 
 		for (j = 0; j < csrow->nr_channels; j++) {
-			struct dimm_info *dimm = csrow->channels[j].dimm;
+			struct dimm_info *dimm = csrow->channels[j]->dimm;
 
 			total_pages += dimm->nr_pages;
 		}
@@ -892,9 +898,12 @@ static const struct attribute_group *mci_attr_groups[] = {
 	NULL
 };
 
-static void mci_attr_release(struct device *device)
+static void mci_attr_release(struct device *dev)
 {
-	debugf1("Releasing mci device %s\n", dev_name(device));
+	struct mem_ctl_info *mci = container_of(dev, struct mem_ctl_info, dev);
+
+	debugf1("Releasing csrow device %s\n", dev_name(dev));
+	kfree(mci);
 }
 
 static struct device_type mci_attr_type = {
@@ -960,7 +969,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	mci->dev.type = &mci_attr_type;
 	device_initialize(&mci->dev);
 
-	mci->dev.parent = &mci_pdev;
+	mci->dev.parent = mci_pdev;
 	mci->dev.bus = &mci->bus;
 	dev_set_name(&mci->dev, "mc%d", mci->mc_idx);
 	dev_set_drvdata(&mci->dev, mci);
@@ -989,7 +998,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	 * Create the dimm/rank devices
 	 */
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		/* Only expose populated DIMMs */
 		if (dimm->nr_pages == 0)
 			continue;
@@ -1026,7 +1035,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 fail:
 	for (i--; i >= 0; i--) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
 		put_device(&dimm->dev);
@@ -1056,7 +1065,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 #endif
 
 	for (i = 0; i < mci->tot_dimms; i++) {
-		struct dimm_info *dimm = &mci->dimms[i];
+		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
 		debugf0("%s(): removing device %s\n", __func__,
@@ -1075,9 +1084,15 @@ void edac_unregister_sysfs(struct mem_ctl_info *mci)
 	kfree(mci->bus.name);
 }
 
-static void mc_attr_release(struct device *device)
+static void mc_attr_release(struct device *dev)
 {
-	debugf1("Releasing device %s\n", dev_name(device));
+	/*
+	 * There's no container structure here, as this is just the mci
+	 * parent device, used to create the /sys/devices/mc sysfs node.
+	 * So, there are no attributes on it.
+	 */
+	debugf1("Releasing device %s\n", dev_name(dev));
+	kfree(dev);
 }
 
 static struct device_type mc_attr_type = {
@@ -1098,12 +1113,14 @@ int __init edac_mc_sysfs_init(void)
 		return -EINVAL;
 	}
 
-	mci_pdev.bus = edac_subsys;
-	mci_pdev.type = &mc_attr_type;
-	device_initialize(&mci_pdev);
-	dev_set_name(&mci_pdev, "mc");
+	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
+
+	mci_pdev->bus = edac_subsys;
+	mci_pdev->type = &mc_attr_type;
+	device_initialize(mci_pdev);
+	dev_set_name(mci_pdev, "mc");
 
-	err = device_add(&mci_pdev);
+	err = device_add(mci_pdev);
 	if (err < 0)
 		return err;
 
@@ -1112,7 +1129,7 @@ int __init edac_mc_sysfs_init(void)
 
 void __exit edac_mc_sysfs_exit(void)
 {
-	put_device(&mci_pdev);
-	device_del(&mci_pdev);
+	put_device(mci_pdev);
+	device_del(mci_pdev);
 	edac_put_sysfs_subsys();
 }
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 0e2cd0b4..63dcb9f 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -409,17 +409,28 @@ struct edac_mc_layer {
  * during the memory allocation routine, with would point to the developer
  * that he's doing something wrong.
  */
-#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
-	typeof(var) __p;						\
+
+#define GET_OFFSET(layers, nlayers, lay0, lay1, lay2) ({		\
+	int i;								\
 	if ((nlayers) == 1)						\
-		__p = &var[lay0];					\
+		i = lay0;						\
 	else if ((nlayers) == 2)					\
-		__p = &var[(lay1) + ((layers[1]).size * (lay0))];	\
+		i = (lay1) + ((layers[1]).size * (lay0));		\
 	else if ((nlayers) == 3)					\
-		__p = &var[(lay2) + ((layers[2]).size * ((lay1) +	\
-			    ((layers[1]).size * (lay0))))];		\
+		i = (lay2) + ((layers[2]).size * ((lay1) +		\
+			    ((layers[1]).size * (lay0))));		\
+	else								\
+		i = -EINVAL;						\
+	i;								\
+})
+
+#define GET_POS(layers, var, nlayers, lay0, lay1, lay2) ({		\
+	typeof(*var) __p;						\
+	int i = GET_OFFSET(layers, nlayers, lay0, lay1, lay2);		\
+	if (i < 0)							\
+		__p = NULL						\
 	else								\
-		__p = NULL;						\
+		__p = (var)[i];					\
 	__p;								\
 })
 
@@ -459,8 +470,6 @@ struct dimm_info {
  *	  patches in this series will fix this issue.
  */
 struct rank_info {
-	struct device dev;
-
 	int chan_idx;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
@@ -486,7 +495,7 @@ struct csrow_info {
 
 	/* channel information for this csrow */
 	u32 nr_channels;
-	struct rank_info *channels;
+	struct rank_info **channels;
 };
 
 /*
@@ -550,7 +559,7 @@ struct mem_ctl_info {
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
 					   unsigned long page);
 	int mc_idx;
-	struct csrow_info *csrows;
+	struct csrow_info **csrows;
 	unsigned num_csrows, num_cschannel;
 
 	/*
@@ -570,7 +579,7 @@ struct mem_ctl_info {
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
 	unsigned tot_dimms;
-	struct dimm_info *dimms;
+	struct dimm_info **dimms;
 
 	/*
 	 * FIXME - what about controllers on other busses? - IDs must be
