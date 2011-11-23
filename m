Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab1KWD14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:27:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39634 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1KWD1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:27:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6538"; a="137842693"
Message-ID: <4ECC6838.1010009@codeaurora.org>
Date: Tue, 22 Nov 2011 19:27:52 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 1/7] amp/remoteproc: add framework for controlling remote
 processors
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <1319536106-25802-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1319536106-25802-2-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/11 02:48, Ohad Ben-Cohen wrote:
> +static int rproc_load_segments(struct rproc *rproc, const u8 *elf_data)
> +{
> +	struct device *dev = rproc->dev;
> +	struct elf32_hdr *ehdr;
> +	struct elf32_phdr *phdr;
> +	int i, ret = 0;
> +
> +	ehdr = (struct elf32_hdr *)elf_data;
> +	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
> +
> +	/* go through the available ELF segments */
> +	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
> +		u32 da = phdr->p_paddr;
> +		u32 memsz = phdr->p_memsz;
> +		u32 filesz = phdr->p_filesz;
> +		void *ptr;
> +
> +		if (phdr->p_type != PT_LOAD)
> +			continue;
> +
> +		dev_dbg(dev, "phdr: type %d da 0x%x memsz 0x%x filesz 0x%x\n",
> +					phdr->p_type, da, memsz, filesz);
> +
> +		if (filesz > memsz) {
> +			dev_err(dev, "bad phdr filesz 0x%x memsz 0x%x\n",
> +							filesz, memsz);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		/* grab the kernel address for this device address */
> +		ptr = rproc_da_to_va(rproc, da, memsz);
> +		if (!ptr) {
> +			dev_err(dev, "bad phdr da 0x%x mem 0x%x\n", da, memsz);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		/* put the segment where the remote processor expects it */
> +		if (phdr->p_filesz)
> +			memcpy(ptr, elf_data + phdr->p_offset, filesz);

How big are the images you're loading? I had to split the memcpy up into
megabyte chunks because I was running out of virtual memory to map in
two huge chunks (one for the firmware and one for the image's resting
place). This may work for now, but I think it will fail for limited
virtual memory environments. Unless CMA solves this problem?

Also, this code assumes the firmware is actually as big as the elf
header says it is. It should be checking to make sure the elf_data is
actually big enough to copy from.

> +
> +		/*
> +		 * Zero out remaining memory for this segment.
> +		 *
> +		 * This isn't strictly required since dma_alloc_coherent already
> +		 * did this for us. albeit harmless, we may consider removing
> +		 * this.
> +		 */
> +		if (memsz > filesz)
> +			memset(ptr + filesz, 0, memsz - filesz);
> +	}
> +
> +	return ret;
> +}
> +
[...]
> +int rproc_register(struct rproc *rproc)
> +{
> +	struct device *dev = rproc->dev;
> +	int ret = 0;
> +
> +	/* expose to rproc_get_by_name users */
> +	klist_add_tail(&rproc->node, &rprocs);
> +
> +	dev_info(rproc->dev, "%s is available\n", rproc->name);
> +
> +	/* create debugfs entries */
> +	rproc_create_debug_dir(rproc);
> +
> +	/* rproc_unregister() calls must wait until async loader completes */
> +	init_completion(&rproc->firmware_loading_complete);
> +
> +	/*
> +	 * We must retrieve early virtio configuration info from
> +	 * the firmware (e.g. whether to register a virtio rpmsg device,
> +	 * what virtio features does it support, ...).
> +	 *
> +	 * We're initiating an asynchronous firmware loading, so we can
> +	 * be built-in kernel code, without hanging the boot process.
> +	 */
> +	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
> +					rproc->firmware, dev, GFP_KERNEL,
> +					rproc, rproc_fw_config_virtio);

This is a bit odd. If I understand correctly, you load the firmware at
least twice. Once to see if the firmware has any virtio devices in the
resource table, and again when the image is actually loaded into RAM. Is
there any way to avoid loading it twice? I ask because we have something
like a 20Mb image that needs to be loaded and I'd like to avoid loading
it twice just to read a section out of it the first time.

> +	if (ret < 0) {
> +		dev_err(dev, "request_firmware_nowait failed: %d\n", ret);
> +		complete_all(&rproc->firmware_loading_complete);
> +		klist_remove(&rproc->node);
> +	}
> +
> +	return ret;
> +}
[...]
> +struct rproc *rproc_alloc(struct device *dev, const char *name,
> +				const struct rproc_ops *ops,
> +				const char *firmware, int len)
> +{
> +	struct rproc *rproc;
> +
> +	if (!dev || !name || !ops)
> +		return NULL;
> +
> +	rproc = kzalloc(sizeof(struct rproc) + len, GFP_KERNEL);
> +	if (!rproc) {
> +		dev_err(dev, "%s: kzalloc failed\n", __func__);
> +		return NULL;
> +	}
> +
> +	rproc->dev = dev;

What do you do if dev goes away? Does request_firmware() work? What do
you think about making remoteproc into a bus? I imagine this function
would allocate a struct device and then rproc_register() would actually
hook it into the device layer. Then we could use the device we allocate
here for the firmware requests and we also have a nice namespace for all
remote processors in the system. Plus all the management code for
refcounting would come for free with the device layer (modulo the
rproc_boot() count).

> +	rproc->name = name;
> +	rproc->ops = ops;
> +	rproc->firmware = firmware;
> +	rproc->priv = &rproc[1];
> +
> +	atomic_set(&rproc->power, 0);
> +
> +	kref_init(&rproc->refcount);
> +
> +	mutex_init(&rproc->lock);
> +
> +	INIT_LIST_HEAD(&rproc->carveouts);
> +	INIT_LIST_HEAD(&rproc->mappings);
> +	INIT_LIST_HEAD(&rproc->traces);
> +
> +	rproc->state = RPROC_OFFLINE;
> +
> +	return rproc;
> +}
> +EXPORT_SYMBOL(rproc_alloc);
> +
[...]
> +/**
> + * enum fw_resource_type - types of resource entries
> + *
> + * @RSC_CARVEOUT:   request for allocation of a physically contiguous
> + *		    memory region.
> + * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
> + * @RSC_TRACE:	    announces the availability of a trace buffer into which
> + *		    the remote processor will be writing logs. In this case,
> + *		    'da' indicates the device address where logs are written to,
> + *		    and 'len' is the size of the trace buffer.
> + * @RSC_VRING:	    request for allocation of a virtio vring (address should
> + *		    be indicated in 'da', and 'len' should contain the number
> + *		    of buffers supported by the vring).
> + * @RSC_VIRTIO_DEV: this entry declares about support for a virtio device,

What is RSC_VIRTIO_CFG?

> +enum fw_resource_type {
> +	RSC_CARVEOUT	= 0,
> +	RSC_DEVMEM	= 1,
> +	RSC_TRACE	= 2,
> +	RSC_VRING	= 3,
> +	RSC_VIRTIO_DEV	= 4,
> +	RSC_VIRTIO_CFG	= 5,
> +};

For MSM I see two main pain points:

 * CMA is new and untested on MSM. I imagine in MSM's situation we would
carve out the memory chunks early on for each processor and then only
remove that memory if the processor is booted? I hope that just works
somehow.

 * rproc is tied to virtio fairly closely. We probably won't be using
virtio anytime soon on MSM, unless we can do smd over virtio or
something. I'm not particularly knowledgeable about that though. Would
something like that be possible?

We would also have to keep using the rproc_get_by_name() approach until
we can actually start tying rproc devices to other devices in the kernel.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

