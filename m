Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2EDKuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2EDKuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:50:14 -0400
Message-ID: <4FA3B40A.1050404@redhat.com>
Date: Fri, 04 May 2012 07:48:42 -0300
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
 with layers, second version
References: <20120502133052.GE12914@aftab.osrc.amd.com> <4FA29356.3040601@redhat.com> <20120504101636.GB18459@aftab.osrc.amd.com>
In-Reply-To: <20120504101636.GB18459@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-05-2012 07:16, Borislav Petkov escreveu:
> On Thu, May 03, 2012 at 11:16:54AM -0300, Mauro Carvalho Chehab wrote:
>> edac: Change internal representation to work with layers
...
>>  /**
>> - * edac_mc_alloc: Allocate a struct mem_ctl_info structure
>> - * @size_pvt:	size of private storage needed
>> - * @nr_csrows:	Number of CWROWS needed for this MC
>> - * @nr_chans:	Number of channels for the MC
>> + * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
>> + * @mc_num:		Memory controller number
>> + * @n_layers:		Number of MC hierarchy layers
>> + * layers:		Describes each layer as seen by the Memory Controller
>> + * @size_pvt:		size of private storage needed
>> + *
>> + *
>> + * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
>> + * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
> 
> 	   DIMMs		   csrow-based
> 
>> + * thing, as two chip select values are used for dual-rank memories (and 4, for
>> + * quad-rank ones). I suspect that this issue could be solved inside the EDAC
>> + * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
> 
> The paragraph above is still in, let me repeat my last note:
> 
> "This last paragraph sounds innacurately, especially the "likely"
> adverbs make it even more confusing. The gist of what you're saying is
> already present in the commit message anyway, so drop it here pls."

There are two similar comments one for edac_mc_alloc and another for new_edac_mc_alloc.
It seems that I fixed just one of them.

> 
>> + *
>> + * In summary, solving this issue is not easy, as it requires a lot of testing.
> 
> As before:
> 
> "Also superfluous and has nothing to do with edac_mc_alloc()."
> 
> Pls remove it.

Dropped both paragraphs.

> 
>>   * Everything is kmalloc'ed as one big chunk - more efficient.
>>   * Only can be used if all structures have the same lifetime - otherwise
>> @@ -168,22 +196,49 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>>   *
>>   * Use edac_mc_free() to free mc structures allocated by this function.
>>   *
>> + * NOTE: drivers handle multi-rank memories in different ways: in some
>> + * drivers, one multi-rank memory stick is mapped as one entry, while, in
>> + * others, a single multi-rank memory stick would be mapped into several
>> + * entries. Currently, this function will allocate multiple struct dimm_info
>> + * on such scenarios, as grouping the multiple ranks require drivers change.
>> + *
>>   * Returns:
>>   *	NULL allocation failed
>>   *	struct mem_ctl_info pointer
> 
> Ok, this patch still doesn't contain all the changes I requested for
> although you said you did them. Is this not the latest version? I'll
> wait for you to sort it out before I continue reviewing...
> 
> Thanks.
> 

Patch enclosed (and updated at Infradead).

Regards,
Mauro

-

edac: Change internal representation to work with layers

Change the EDAC internal representation to work with non-csrow
based memory controllers.

There are lots of those memory controllers nowadays, and more
are coming. So, the EDAC internal representation needs to be
changed, in order to work with those memory controllers, while
preserving backward compatibility with the old ones.

The edac core was written with the idea that memory controllers
are able to directly access csrows.

This is not true for FB-DIMM and RAMBUS memory controllers.

Also, some recent advanced memory controllers don't present a per-csrows
view. Instead, they view memories as DIMMs, instead of ranks.

So, change the allocation and error report routines to allow
them to work with all types of architectures.

This will allow the removal of several hacks with FB-DIMM and RAMBUS
memory controllers.

Also, several tests were done on different platforms using different
x86 drivers.

TODO: a multi-rank DIMMs are currently represented by multiple DIMM
entries in struct dimm_info. That means that changing a label for one
rank won't change the same label for the other ranks at the same DIMM.
This bug is present since the beginning of the EDAC, so it is not a big
deal. However, on several drivers, it is possible to fix this issue, but
it should be a per-driver fix, as the csrow => DIMM arrangement may not
be equal for all. So, don't try to fix it here yet.

I tried to make this patch as short as possible, preceding it with
several other patches that simplified the logic here. Yet, as the
internal API changes, all drivers need changes. The changes are
generally bigger in the drivers for FB-DIMMs.

Cc: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mark Gross <mark.gross@intel.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Tim Small <tim@buttersideup.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
v19: dropped 2 comment paragraphs, as above.

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index e48ab31..1286c5e 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -447,8 +447,12 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 
 #endif				/* CONFIG_PCI */
 
-extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-					  unsigned nr_chans, int edac_index);
+struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
+				   unsigned nr_chans, int edac_index);
+struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
+				   unsigned n_layers,
+				   struct edac_mc_layer *layers,
+				   unsigned sz_pvt);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci);
 extern void edac_mc_free(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
@@ -467,24 +471,78 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
  * reporting logic and function interface - reduces conditional
  * statement clutter and extra function arguments.
  */
-extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page,
-			      unsigned long syndrome, int row, int channel,
-			      const char *msg);
-extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
-				      const char *msg);
-extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
-			      unsigned long page_frame_number,
-			      unsigned long offset_in_page, int row,
-			      const char *msg);
-extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
-				      const char *msg);
-extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci, unsigned int csrow,
-				  unsigned int channel0, unsigned int channel1,
-				  char *msg);
-extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci, unsigned int csrow,
-				  unsigned int channel, char *msg);
+
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
+			  const char *msg,
+			  const char *other_detail,
+			  const void *mcelog);
+
+static inline void edac_mc_handle_ce(struct mem_ctl_info *mci,
+				     unsigned long page_frame_number,
+				     unsigned long offset_in_page,
+				     unsigned long syndrome, int row, int channel,
+				     const char *msg)
+{
+	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			      page_frame_number, offset_in_page, syndrome,
+			      row, channel, -1, msg, NULL, NULL);
+}
+
+static inline void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
+					     const char *msg)
+{
+	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
+}
+
+static inline void edac_mc_handle_ue(struct mem_ctl_info *mci,
+				     unsigned long page_frame_number,
+				     unsigned long offset_in_page, int row,
+				     const char *msg)
+{
+	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			      page_frame_number, offset_in_page, 0,
+			      row, -1, -1, msg, NULL, NULL);
+}
+
+static inline void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
+					     const char *msg)
+{
+	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
+}
+
+static inline void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
+					 unsigned int csrow,
+					 unsigned int channel0,
+					 unsigned int channel1,
+					 char *msg)
+{
+	/*
+	 *FIXME: The error can also be at channel1 (e. g. at the second
+	 *	  channel of the same branch). The fix is to push
+	 *	  edac_mc_handle_error() call into each driver
+	 */
+	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
+			      0, 0, 0,
+			      csrow, channel0, -1, msg, NULL, NULL);
+}
+
+static inline void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
+					 unsigned int csrow,
+					 unsigned int channel, char *msg)
+{
+	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
+			      0, 0, 0,
+			      csrow, channel, -1, msg, NULL, NULL);
+}
 
 /*
  * edac_device APIs
@@ -496,6 +554,7 @@ extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
 extern int edac_device_alloc_index(void);
+extern const char *edac_layer_name[];
 
 /*
  * edac_pci APIs
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 6ec967a..4365079 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -44,9 +44,25 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
-	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
-	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
-	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
+	debugf4("\tchannel->dimm = %p\n", chan->dimm);
+}
+
+static void edac_mc_dump_dimm(struct dimm_info *dimm)
+{
+	int i;
+
+	debugf4("\tdimm = %p\n", dimm);
+	debugf4("\tdimm->label = '%s'\n", dimm->label);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
+	debugf4("\tdimm location ");
+	for (i = 0; i < dimm->mci->n_layers; i++) {
+		printk(KERN_CONT "%d", dimm->location[i]);
+		if (i < dimm->mci->n_layers - 1)
+			printk(KERN_CONT ".");
+	}
+	printk(KERN_CONT "\n");
+	debugf4("\tdimm->grain = %d\n", dimm->grain);
+	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
@@ -70,6 +86,8 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
 	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
 		mci->nr_csrows, mci->csrows);
+	debugf3("\tmci->nr_dimms = %d, dimms = %p\n",
+		mci->tot_dimms, mci->dimms);
 	debugf3("\tdev = %p\n", mci->dev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
@@ -157,10 +175,12 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
 }
 
 /**
- * edac_mc_alloc: Allocate a struct mem_ctl_info structure
- * @size_pvt:	size of private storage needed
- * @nr_csrows:	Number of CWROWS needed for this MC
- * @nr_chans:	Number of channels for the MC
+ * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
+ * @mc_num:		Memory controller number
+ * @n_layers:		Number of MC hierarchy layers
+ * layers:		Describes each layer as seen by the Memory Controller
+ * @size_pvt:		size of private storage needed
+ *
  *
  * Everything is kmalloc'ed as one big chunk - more efficient.
  * Only can be used if all structures have the same lifetime - otherwise
@@ -168,22 +188,49 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
  *
  * Use edac_mc_free() to free mc structures allocated by this function.
  *
+ * NOTE: drivers handle multi-rank memories in different ways: in some
+ * drivers, one multi-rank memory stick is mapped as one entry, while, in
+ * others, a single multi-rank memory stick would be mapped into several
+ * entries. Currently, this function will allocate multiple struct dimm_info
+ * on such scenarios, as grouping the multiple ranks require drivers change.
+ *
  * Returns:
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
  */
-struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				unsigned nr_chans, int edac_index)
+struct mem_ctl_info *new_edac_mc_alloc(unsigned mc_num,
+				       unsigned n_layers,
+				       struct edac_mc_layer *layers,
+				       unsigned sz_pvt)
 {
-	void *ptr = NULL;
 	struct mem_ctl_info *mci;
-	struct csrow_info *csi, *csrow;
+	struct edac_mc_layer *layer;
+	struct csrow_info *csi, *csr;
 	struct rank_info *chi, *chp, *chan;
 	struct dimm_info *dimm;
-	void *pvt;
-	unsigned size;
-	int row, chn;
-	int err;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
+	unsigned pos[EDAC_MAX_LAYERS];
+	void *pvt, *ptr = NULL;
+	unsigned size, tot_dimms = 1, count = 1;
+	unsigned tot_csrows = 1, tot_channels = 1, tot_errcount = 0;
+	int i, j, err, row, chn;
+	bool per_rank = false;
+
+	BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
+	/*
+	 * Calculate the total amount of dimms and csrows/cschannels while
+	 * in the old API emulation mode
+	 */
+	for (i = 0; i < n_layers; i++) {
+		tot_dimms *= layers[i].size;
+		if (layers[i].is_virt_csrow)
+			tot_csrows *= layers[i].size;
+		else
+			tot_channels *= layers[i].size;
+
+		if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
+			per_rank = true;
+	}
 
 	/* Figure out the offsets of the various items from the start of an mc
 	 * structure.  We want the alignment of each item to be at least as
@@ -191,12 +238,27 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * hardcode everything into a single struct.
 	 */
 	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
-	csi = edac_align_ptr(&ptr, sizeof(*csi), nr_csrows);
-	chi = edac_align_ptr(&ptr, sizeof(*chi), nr_csrows * nr_chans);
-	dimm = edac_align_ptr(&ptr, sizeof(*dimm), nr_csrows * nr_chans);
+	layer = edac_align_ptr(&ptr, sizeof(*layer), n_layers);
+	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
+	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_channels);
+	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
+	for (i = 0; i < n_layers; i++) {
+		count *= layers[i].size;
+		debugf4("%s: errcount layer %d size %d\n", __func__, i, count);
+		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		tot_errcount += 2 * count;
+	}
+
+	debugf4("%s: allocating %d error counters\n", __func__, tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
+	debugf1("%s(): allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
+		__func__, size,
+		tot_dimms,
+		per_rank ? "ranks" : "dimms",
+		tot_csrows * tot_channels);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -204,42 +266,90 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	/* Adjust pointers so they point within the memory we just allocated
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
+	layer = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)layer));
 	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
 	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
 	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
+	for (i = 0; i < n_layers; i++) {
+		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
+		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
+	}
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
 	/* setup index and various internal pointers */
-	mci->mc_idx = edac_index;
+	mci->mc_idx = mc_num;
 	mci->csrows = csi;
 	mci->dimms  = dimm;
+	mci->tot_dimms = tot_dimms;
 	mci->pvt_info = pvt;
-	mci->nr_csrows = nr_csrows;
+	mci->n_layers = n_layers;
+	mci->layers = layer;
+	memcpy(mci->layers, layers, sizeof(*layer) * n_layers);
+	mci->nr_csrows = tot_csrows;
+	mci->num_cschannel = tot_channels;
+	mci->mem_is_per_rank = per_rank;
 
 	/*
-	 * For now, assumes that a per-csrow arrangement for dimms.
-	 * This will be latter changed.
+	 * Fill the csrow struct
 	 */
-	dimm = mci->dimms;
-
-	for (row = 0; row < nr_csrows; row++) {
-		csrow = &csi[row];
-		csrow->csrow_idx = row;
-		csrow->mci = mci;
-		csrow->nr_channels = nr_chans;
-		chp = &chi[row * nr_chans];
-		csrow->channels = chp;
-
-		for (chn = 0; chn < nr_chans; chn++) {
+	for (row = 0; row < tot_csrows; row++) {
+		csr = &csi[row];
+		csr->csrow_idx = row;
+		csr->mci = mci;
+		csr->nr_channels = tot_channels;
+		chp = &chi[row * tot_channels];
+		csr->channels = chp;
+
+		for (chn = 0; chn < tot_channels; chn++) {
 			chan = &chp[chn];
 			chan->chan_idx = chn;
-			chan->csrow = csrow;
+			chan->csrow = csr;
+		}
+	}
 
-			mci->csrows[row].channels[chn].dimm = dimm;
-			dimm->csrow = row;
-			dimm->csrow_channel = chn;
-			dimm++;
-			mci->nr_dimms++;
+	/*
+	 * Fill the dimm struct
+	 */
+	memset(&pos, 0, sizeof(pos));
+	row = 0;
+	chn = 0;
+	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
+		per_rank ? "ranks" : "dimms");
+	for (i = 0; i < tot_dimms; i++) {
+		chan = &csi[row].channels[chn];
+		dimm = EDAC_DIMM_PTR(layer, mci->dimms, n_layers,
+			       pos[0], pos[1], pos[2]);
+		dimm->mci = mci;
+
+		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
+			pos[0], pos[1], pos[2], row, chn);
+
+		/* Copy DIMM location */
+		for (j = 0; j < n_layers; j++)
+			dimm->location[j] = pos[j];
+
+		/* Link it to the csrows old API data */
+		chan->dimm = dimm;
+		dimm->csrow = row;
+		dimm->cschannel = chn;
+
+		/* Increment csrow location */
+		for (j = n_layers - 1; j >= 0; j--)
+			if (layers[j].is_virt_csrow)
+				break;
+		row++;
+		if (row == tot_csrows) {
+			row = 0;
+			chn++;
+		}
+
+		/* Increment dimm location */
+		for (j = n_layers - 1; j >= 0; j--) {
+			pos[j]++;
+			if (pos[j] < layers[j].size)
+				break;
+			pos[j] = 0;
 		}
 	}
 
@@ -263,6 +373,46 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 */
 	return mci;
 }
+EXPORT_SYMBOL_GPL(new_edac_mc_alloc);
+
+/**
+ * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
+ * @mc_num:		Memory controller number
+ * @n_layers:		Number of layers at the MC hierarchy
+ * layers:		Describes each layer as seen by the Memory Controller
+ * @size_pvt:		Size of private storage needed
+ *
+ *
+ * FIXME: drivers handle multi-rank memories in different ways: some
+ * drivers map multi-ranked DIMMs as one DIMM while others
+ * as several DIMMs.
+ *
+ * Everything is kmalloc'ed as one big chunk - more efficient.
+ * It can only be used if all structures have the same lifetime - otherwise
+ * you have to allocate and initialize your own structures.
+ *
+ * Use edac_mc_free() to free mc structures allocated by this function.
+ *
+ * Returns:
+ *	On failure: NULL
+ *	On success: struct mem_ctl_info pointer
+ */
+
+struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
+				   unsigned nr_chans, int mc_num)
+{
+	unsigned n_layers = 2;
+	struct edac_mc_layer layers[n_layers];
+
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = nr_csrows;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = nr_chans;
+	layers[1].is_virt_csrow = false;
+
+	return new_edac_mc_alloc(mc_num, ARRAY_SIZE(layers), layers, sz_pvt);
+}
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
 
 /**
@@ -528,7 +678,6 @@ EXPORT_SYMBOL(edac_mc_find);
  * edac_mc_add_mc: Insert the 'mci' structure into the mci global list and
  *                 create sysfs entries associated with mci structure
  * @mci: pointer to the mci structure to be added to the list
- * @mc_idx: A unique numeric identifier to be assigned to the 'mci' structure.
  *
  * Return:
  *	0	Success
@@ -555,6 +704,8 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 				edac_mc_dump_channel(&mci->csrows[i].
 						channels[j]);
 		}
+		for (i = 0; i < mci->tot_dimms; i++)
+			edac_mc_dump_dimm(&mci->dimms[i]);
 	}
 #endif
 	mutex_lock(&mem_ctls_mutex);
@@ -712,261 +863,289 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 }
 EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
 
-/* FIXME - setable log (warning/emerg) levels */
-/* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
-void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, unsigned long syndrome,
-		int row, int channel, const char *msg)
+const char *edac_layer_name[] = {
+	[EDAC_MC_LAYER_BRANCH] = "branch",
+	[EDAC_MC_LAYER_CHANNEL] = "channel",
+	[EDAC_MC_LAYER_SLOT] = "slot",
+	[EDAC_MC_LAYER_CHIP_SELECT] = "csrow",
+};
+EXPORT_SYMBOL_GPL(edac_layer_name);
+
+static void edac_inc_ce_error(struct mem_ctl_info *mci,
+				    bool enable_per_layer_report,
+				    const int pos[EDAC_MAX_LAYERS])
 {
-	unsigned long remapped_page;
-	char *label = NULL;
-	u32 grain;
+	int i, index = 0;
 
-	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
+	mci->ce_count++;
 
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+	if (!enable_per_layer_report) {
+		mci->ce_noinfo_count++;
 		return;
 	}
 
-	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range "
-			"(%d >= %d)\n", channel,
-			mci->csrows[row].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ce_per_layer[i][index]++;
+
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
+	}
+}
+
+static void edac_inc_ue_error(struct mem_ctl_info *mci,
+				    bool enable_per_layer_report,
+				    const int pos[EDAC_MAX_LAYERS])
+{
+	int i, index = 0;
+
+	mci->ue_count++;
+
+	if (!enable_per_layer_report) {
+		mci->ce_noinfo_count++;
 		return;
 	}
 
-	label = mci->csrows[row].channels[channel].dimm->label;
-	grain = mci->csrows[row].channels[channel].dimm->grain;
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			break;
+		index += pos[i];
+		mci->ue_per_layer[i][index]++;
+
+		if (i < mci->n_layers - 1)
+			index *= mci->layers[i + 1].size;
+	}
+}
+
+static void edac_ce_error(struct mem_ctl_info *mci,
+			  const int pos[EDAC_MAX_LAYERS],
+			  const char *msg,
+			  const char *location,
+			  const char *label,
+			  const char *detail,
+			  const char *other_detail,
+			  const bool enable_per_layer_report,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  u32 grain)
+{
+	unsigned long remapped_page;
 
 	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
-			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
-			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
-			page_frame_number, offset_in_page,
-			grain, syndrome, row, channel,
-			label, msg);
-
-	mci->ce_count++;
-	mci->csrows[row].ce_count++;
-	mci->csrows[row].channels[channel].dimm->ce_count++;
-	mci->csrows[row].channels[channel].ce_count++;
+				"CE %s on %s (%s%s %s)\n",
+				msg, label, location,
+				detail, other_detail);
+	edac_inc_ce_error(mci, enable_per_layer_report, pos);
 
 	if (mci->scrub_mode & SCRUB_SW_SRC) {
 		/*
-		 * Some MC's can remap memory so that it is still available
-		 * at a different address when PCI devices map into memory.
-		 * MC's that can't do this lose the memory where PCI devices
-		 * are mapped.  This mapping is MC dependent and so we call
-		 * back into the MC driver for it to map the MC page to
-		 * a physical (CPU) page which can then be mapped to a virtual
-		 * page - which can then be scrubbed.
-		 */
+			* Some memory controllers (called MCs below) can remap
+			* memory so that it is still available at a different
+			* address when PCI devices map into memory.
+			* MC's that can't do this, lose the memory where PCI
+			* devices are mapped. This mapping is MC-dependent
+			* and so we call back into the MC driver for it to
+			* map the MC page to a physical (CPU) page which can
+			* then be mapped to a virtual page - which can then
+			* be scrubbed.
+			*/
 		remapped_page = mci->ctl_page_to_phys ?
 			mci->ctl_page_to_phys(mci, page_frame_number) :
 			page_frame_number;
 
-		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
+		edac_mc_scrub_block(remapped_page,
+					offset_in_page, grain);
 	}
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
-void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
+static void edac_ue_error(struct mem_ctl_info *mci,
+			  const int pos[EDAC_MAX_LAYERS],
+			  const char *msg,
+			  const char *location,
+			  const char *label,
+			  const char *detail,
+			  const char *other_detail,
+			  const bool enable_per_layer_report)
 {
-	if (edac_mc_get_log_ce())
+	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_WARNING,
-			"CE - no information available: %s\n", msg);
+			"UE %s on %s (%s%s %s)\n",
+			msg, label, location, detail, other_detail);
 
-	mci->ce_noinfo_count++;
-	mci->ce_count++;
+	if (edac_mc_get_panic_on_ue())
+		panic("UE %s on %s (%s%s %s)\n",
+			msg, label, location, detail, other_detail);
+
+	edac_inc_ue_error(mci, enable_per_layer_report, pos);
 }
-EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
 
-void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, int row, const char *msg)
+#define OTHER_LABEL " or "
+void edac_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const int layer0,
+			  const int layer1,
+			  const int layer2,
+			  const char *msg,
+			  const char *other_detail,
+			  const void *mcelog)
 {
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chan;
-	int chars;
-	char *label = NULL;
+	/* FIXME: too much for stack: move it to some pre-alocated area */
+	char detail[80], location[80];
+	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
+	char *p;
+	int row = -1, chan = -1;
+	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
+	int i;
 	u32 grain;
+	bool enable_per_layer_report = false;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
-	/* FIXME - maybe make panic on INTERNAL ERROR an option */
-	if (row >= mci->nr_csrows || row < 0) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range "
-			"(%d >= %d)\n", row, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
-
-	grain = mci->csrows[row].channels[0].dimm->grain;
-	label = mci->csrows[row].channels[0].dimm->label;
-	chars = snprintf(pos, len + 1, "%s", label);
-	len -= chars;
-	pos += chars;
-
-	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
-		chan++) {
-		label = mci->csrows[row].channels[chan].dimm->label;
-		chars = snprintf(pos, len + 1, ":%s", label);
-		len -= chars;
-		pos += chars;
+	/*
+	 * Check if the event report is consistent and if the memory
+	 * location is known. If it is known, enable_per_layer_report will be
+	 * true, the DIMM(s) label info will be filled and the per-layer
+	 * error counters will be incremented.
+	 */
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] >= (int)mci->layers[i].size) {
+			if (type == HW_EVENT_ERR_CORRECTED)
+				p = "CE";
+			else
+				p = "UE";
+
+			edac_mc_printk(mci, KERN_ERR,
+				       "INTERNAL ERROR: %s value is out of range (%d >= %d)\n",
+				       edac_layer_name[mci->layers[i].type],
+				       pos[i], mci->layers[i].size);
+			/*
+			 * Instead of just returning it, let's use what's
+			 * known about the error. The increment routines and
+			 * the DIMM filter logic will do the right thing by
+			 * pointing the likely damaged DIMMs.
+			 */
+			pos[i] = -1;
+		}
+		if (pos[i] >= 0)
+			enable_per_layer_report = true;
 	}
 
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_EMERG,
-			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
-			"labels \"%s\": %s\n", page_frame_number,
-			offset_in_page, grain, row, labels, msg);
-
-	if (edac_mc_get_panic_on_ue())
-		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
-			"row %d, labels \"%s\": %s\n", mci->mc_idx,
-			page_frame_number, offset_in_page,
-			grain, row, labels, msg);
-
-	mci->ue_count++;
-	mci->csrows[row].ue_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
+	/*
+	 * Get the dimm label/grain that applies to the match criteria.
+	 * As the error algorithm may not be able to point to just one memory
+	 * stick, the logic here will get all possible labels that could
+	 * pottentially be affected by the error.
+	 * On FB-DIMM memory controllers, for uncorrected errors, it is common
+	 * to have only the MC channel and the MC dimm (also called "branch")
+	 * but the channel is not known, as the memory is arranged in pairs,
+	 * where each memory belongs to a separate channel within the same
+	 * branch.
+	 */
+	grain = 0;
+	p = label;
+	*p = '\0';
+	for (i = 0; i < mci->tot_dimms; i++) {
+		struct dimm_info *dimm = &mci->dimms[i];
 
-void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
-{
-	if (edac_mc_get_panic_on_ue())
-		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
+		if (layer0 >= 0 && layer0 != dimm->location[0])
+			continue;
+		if (layer1 >= 0 && layer1 != dimm->location[1])
+			continue;
+		if (layer2 >= 0 && layer2 != dimm->location[2])
+			continue;
 
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_WARNING,
-			"UE - no information available: %s\n", msg);
-	mci->ue_noinfo_count++;
-	mci->ue_count++;
-}
-EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
+		/* get the max grain, over the error match range */
+		if (dimm->grain > grain)
+			grain = dimm->grain;
 
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process UE events
- */
-void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-			unsigned int csrow,
-			unsigned int channela,
-			unsigned int channelb, char *msg)
-{
-	int len = EDAC_MC_LABEL_LEN * 4;
-	char labels[len + 1];
-	char *pos = labels;
-	int chars;
-	char *label;
-
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
-
-	if (channela >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-a out of range "
-			"(%d >= %d)\n",
-			channela, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
+		/*
+		 * If the error is memory-controller wide, there's no need to
+		 * seek for the affected DIMMs because the whole
+		 * channel/memory controller/...  may be affected.
+		 * Also, don't show errors for empty DIMM slots.
+		 */
+		if (enable_per_layer_report && dimm->nr_pages) {
+			if (p != label) {
+				strcpy(p, OTHER_LABEL);
+				p += strlen(OTHER_LABEL);
+			}
+			strcpy(p, dimm->label);
+			p += strlen(p);
+			*p = '\0';
+
+			/*
+			 * get csrow/channel of the DIMM, in order to allow
+			 * incrementing the compat API counters
+			 */
+			debugf4("%s: %s csrows map: (%d,%d)\n",
+				__func__,
+				mci->mem_is_per_rank ? "rank" : "dimm",
+				dimm->csrow, dimm->cschannel);
+
+			if (row == -1)
+				row = dimm->csrow;
+			else if (row >= 0 && row != dimm->csrow)
+				row = -2;
+
+			if (chan == -1)
+				chan = dimm->cschannel;
+			else if (chan >= 0 && chan != dimm->cschannel)
+				chan = -2;
+		}
 	}
 
-	if (channelb >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel-b out of range "
-			"(%d >= %d)\n",
-			channelb, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
-		return;
+	if (!enable_per_layer_report) {
+		strcpy(label, "any memory");
+	} else {
+		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
+			__func__, row, chan);
+		if (p == label)
+			strcpy(label, "unknown memory");
+		if (type == HW_EVENT_ERR_CORRECTED) {
+			if (row >= 0) {
+				mci->csrows[row].ce_count++;
+				if (chan >= 0)
+					mci->csrows[row].channels[chan].ce_count++;
+			}
+		} else
+			if (row >= 0)
+				mci->csrows[row].ue_count++;
 	}
 
-	mci->ue_count++;
-	mci->csrows[csrow].ue_count++;
-
-	/* Generate the DIMM labels from the specified channels */
-	label = mci->csrows[csrow].channels[channela].dimm->label;
-	chars = snprintf(pos, len + 1, "%s", label);
-	len -= chars;
-	pos += chars;
-
-	chars = snprintf(pos, len + 1, "-%s",
-			mci->csrows[csrow].channels[channelb].dimm->label);
-
-	if (edac_mc_get_log_ue())
-		edac_mc_printk(mci, KERN_EMERG,
-			"UE row %d, channel-a= %d channel-b= %d "
-			"labels \"%s\": %s\n", csrow, channela, channelb,
-			labels, msg);
-
-	if (edac_mc_get_panic_on_ue())
-		panic("UE row %d, channel-a= %d channel-b= %d "
-			"labels \"%s\": %s\n", csrow, channela,
-			channelb, labels, msg);
-}
-EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
-
-/*************************************************************
- * On Fully Buffered DIMM modules, this help function is
- * called to process CE events
- */
-void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-			unsigned int csrow, unsigned int channel, char *msg)
-{
-	char *label = NULL;
+	/* Fill the RAM location data */
+	p = location;
+	for (i = 0; i < mci->n_layers; i++) {
+		if (pos[i] < 0)
+			continue;
 
-	/* Ensure boundary values */
-	if (csrow >= mci->nr_csrows) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: row out of range (%d >= %d)\n",
-			csrow, mci->nr_csrows);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
-	}
-	if (channel >= mci->csrows[csrow].nr_channels) {
-		/* something is wrong */
-		edac_mc_printk(mci, KERN_ERR,
-			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
-			channel, mci->csrows[csrow].nr_channels);
-		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
-		return;
+		p += sprintf(p, "%s %d ",
+			     edac_layer_name[mci->layers[i].type],
+			     pos[i]);
 	}
 
-	label = mci->csrows[csrow].channels[channel].dimm->label;
+	/* Memory type dependent details about the error */
+	if (type == HW_EVENT_ERR_CORRECTED) {
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx",
+			page_frame_number, offset_in_page,
+			grain, syndrome);
 
-	if (edac_mc_get_log_ce())
-		/* FIXME - put in DIMM location */
-		edac_mc_printk(mci, KERN_WARNING,
-			"CE row %d, channel %d, label \"%s\": %s\n",
-			csrow, channel, label, msg);
+		edac_ce_error(mci, pos, msg, location, label, detail,
+			      other_detail, enable_per_layer_report,
+			      page_frame_number, offset_in_page, grain);
+	} else {
+		snprintf(detail, sizeof(detail),
+			"page 0x%lx offset 0x%lx grain %d",
+			page_frame_number, offset_in_page, grain);
 
-	mci->ce_count++;
-	mci->csrows[csrow].ce_count++;
-	mci->csrows[csrow].channels[channel].dimm->ce_count++;
-	mci->csrows[csrow].channels[channel].ce_count++;
+		edac_ue_error(mci, pos, msg, location, label, detail,
+			      other_detail, enable_per_layer_report);
+	}
 }
-EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
+EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 3b8798d..c8f507d 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -412,18 +412,20 @@ struct edac_mc_layer {
 /* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
-	unsigned memory_controller;
-	unsigned csrow;
-	unsigned csrow_channel;
+
+	/* Memory location data */
+	unsigned location[EDAC_MAX_LAYERS];
+
+	struct mem_ctl_info *mci;	/* the parent */
 
 	u32 grain;		/* granularity of reported error in bytes */
 	enum dev_type dtype;	/* memory device type */
 	enum mem_type mtype;	/* memory dimm type */
 	enum edac_type edac_mode;	/* EDAC mode for this dimm */
 
-	u32 nr_pages;			/* number of pages in csrow */
+	u32 nr_pages;			/* number of pages on this dimm */
 
-	u32 ce_count;		/* Correctable Errors for this dimm */
+	unsigned csrow, cschannel;	/* Points to the old API data */
 };
 
 /**
@@ -443,9 +445,10 @@ struct dimm_info {
  */
 struct rank_info {
 	int chan_idx;
-	u32 ce_count;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
+
+	u32 ce_count;		/* Correctable Errors for this csrow */
 };
 
 struct csrow_info {
@@ -541,13 +544,18 @@ struct mem_ctl_info {
 	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
 					   unsigned long page);
 	int mc_idx;
-	int nr_csrows;
 	struct csrow_info *csrows;
+	unsigned nr_csrows, num_cschannel;
+
+	/* Memory Controller hierarchy */
+	unsigned n_layers;
+	struct edac_mc_layer *layers;
+	bool mem_is_per_rank;
 
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
-	unsigned nr_dimms;
+	unsigned tot_dimms;
 	struct dimm_info *dimms;
 
 	/*
@@ -562,12 +570,16 @@ struct mem_ctl_info {
 	const char *dev_name;
 	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
-	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
-	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
-	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
-	u32 ce_count;		/* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
+	/*
+	 * drivers shouldn't access those fields directly, as the core
+	 * already handles that.
+	 */
+	u32 ce_noinfo_count, ue_noinfo_count;
+	u32 ue_count, ce_count;
+	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
+
 	struct completion complete;
 
 	/* edac sysfs device control */
@@ -580,7 +592,7 @@ struct mem_ctl_info {
 	 * by the low level driver.
 	 *
 	 * Set by the low level driver to provide attributes at the
-	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * controller level.
 	 * An array of structures, NULL terminated
 	 *
 	 * If attributes are desired, then set to array of attributes
