Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2DFLyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 07:54:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55663 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2DFLyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 07:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
References: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
Date: Fri, 6 Apr 2012 19:54:38 +0800
Message-ID: <CAGjg+kHjUcYEnszBE4RdbeU52Nao0jJa56JXk180aONMbn-JBA@mail.gmail.com>
Subject: Re: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
From: Alex Shi <lkml.alex@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: JBottomley@parallels.com, Nagalakshmi.Nandigama@lsi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the following patch, the driver will have many complain after
smp_processor_id debug enabled.

So would you like consider to pick this patch or find a better way to
remove them?

Call Trace:^M
 [<ffffffff81325f77>] debug_smp_processor_id+0xe7/0x100^M
 [<ffffffffa0016324>] mpt2sas_base_put_smid_default+0x34/0x70 [mpt2sas]^M
 [<ffffffffa0016472>] _base_event_notification+0x112/0x240 [mpt2sas]^M
 [<ffffffffa0016a11>] _base_make_ioc_operational+0x471/0x1240 [mpt2sas]^M
 [<ffffffff810b9963>] ? lockdep_init_map+0xa3/0x560^M
 [<ffffffff810be4fd>] ? trace_hardirqs_on_caller+0x10d/0x1a0^M
 [<ffffffff810b8588>] ? debug_mutex_init+0x38/0x50^M
 [<ffffffffa00193c7>] mpt2sas_base_attach+0x1237/0x1630 [mpt2sas]^M
 [<ffffffffa001ecf8>] _scsih_probe+0x408/0x620 [mpt2sas]^M
 [<ffffffff8133c64c>] local_pci_probe+0x5c/0xd0^M
 [<ffffffff8133df41>] pci_device_probe+0x101/0x120^M
 [<ffffffff814190dc>] driver_probe_device+0x9c/0x300^M
 [<ffffffff814193eb>] __driver_attach+0xab/0xb0^M
 [<ffffffff81419340>] ? driver_probe_device+0x300/0x300^M
 [<ffffffff8141747e>] bus_for_each_dev+0x5e/0x90^M
 [<ffffffff81418cee>] driver_attach+0x1e/0x20^M
 [<ffffffff814188e0>] bus_add_driver+0x1c0/0x2b0^M

On Mon, Mar 26, 2012 at 2:20 PM, Alex Shi <alex.shi@intel.com> wrote:
> commit 911ae943 add a new function:
> +_base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
> +{
> +       return ioc->cpu_msix_table[smp_processor_id()];
> +}
> Here smp_processor_id() need be used in preempt safe condition. but
> caller did not give this assurance. So fix this in caller.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index a78036f..55a368e 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1803,6 +1803,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
>        u64 *request = (u64 *)&descriptor;
>
>
> +       preempt_disable();
>        descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
>        descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
>        descriptor.SCSIIO.SMID = cpu_to_le16(smid);
> @@ -1810,6 +1811,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
>        descriptor.SCSIIO.LMID = 0;
>        _base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
>            &ioc->scsi_lookup_lock);
> +       preempt_enable();
>  }
>
>
> @@ -1849,6 +1851,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
>        Mpi2RequestDescriptorUnion_t descriptor;
>        u64 *request = (u64 *)&descriptor;
>
> +       preempt_disable();
>        descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
>        descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
>        descriptor.Default.SMID = cpu_to_le16(smid);
> @@ -1856,6 +1859,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
>        descriptor.Default.DescriptorTypeDependent = 0;
>        _base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
>            &ioc->scsi_lookup_lock);
> +       preempt_enable();
>  }
>
>  /**
> @@ -1873,6 +1877,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
>        Mpi2RequestDescriptorUnion_t descriptor;
>        u64 *request = (u64 *)&descriptor;
>
> +       preempt_disable();
>        descriptor.SCSITarget.RequestFlags =
>            MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
>        descriptor.SCSITarget.MSIxIndex =  _base_get_msix_index(ioc);
> @@ -1881,6 +1886,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
>        descriptor.SCSITarget.IoIndex = cpu_to_le16(io_index);
>        _base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
>            &ioc->scsi_lookup_lock);
> +       preempt_enable();
>  }
>
>  /**
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
