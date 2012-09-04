Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2IDWOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:14:55 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:36532 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IDWOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:14:53 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 18:14:53 EDT
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: RE: [RESEND][PATCH v4 0/3] make efivars/efi_pstore interrupt-safe
Thread-Topic: [RESEND][PATCH v4 0/3] make efivars/efi_pstore interrupt-safe
Thread-Index: Ac2K54VYIT+D1QatRhGlRDeIAxe21QAAso6w
Date: Tue, 4 Sep 2012 22:14:15 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413826F2E@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413826EB1@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413826EB1@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-04_07:2012-09-04,2012-09-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=8 phishscore=0 bulkscore=66 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1209040250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

Could you please review this patchset?
I talked to Tony about it in Plumbers conference last week and he told that your review is needed because it is efi-specific.

Seiji

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Seiji Aguchi
> Sent: Tuesday, September 04, 2012 6:06 PM
> To: Mike Waychison; linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); Matthew Garrett (mjg@redhat.com);
> dzickus@redhat.com; linux-efi@vger.kernel.org
> Cc: dle-develop@lists.sourceforge.net; Satoru Moriya
> Subject: [RESEND][PATCH v4 0/3] make efivars/efi_pstore interrupt-safe
> 
> Changelog
> v3 -> v4
>   - Patch 2/3
>     Move cancel_work_sync() above an efi_enabled test in efivars_exit().
> 
> v2 -> v3
>   - Patch 1/3
>     Replace spin_lock_irqsave/spin_unlock_irqrestore with spin_lock_irq/spin_unlock_irq in efivars_unregister(),
>     efivar_create(), efivar_store_raw() and efivar_delete() which are called in a process context.
> 
>  - Patch 2/3
>     Change a name of delete_sysfs_entry() to delete_all_stale_sysfs_entries().
>     Also, don't release an efivar->lock while searching efivar->list in delete_all_stale_sysfs_entries().
> 
>  - Patch 3/3
>     Remove a logic in efi_pstore_erase() which freshly created in patch v2.
> 
> v1 -> v2
>  - Patch 1/3
>     Add spin_lock_irq/spin_unlock_irq to open/close callbacks of efi_pstore
>     instead of moving spin_locks to a read callback.
> 
>  - Patch 2/3
>     Replace a periodical timer with schedule_work().
> 
>  - Patch 3/3
>     freshly create to kick a workqueue in oops case only.
> 
> [Problem]
>  There are following problems related to an interrupt context in efivar/efi_pstore.
> 
>  Currently, efivars enables interrupt while taking efivars->lock.
>  So, there is a risk to be deadlocking in a write callback of efi_pstore if kernel panics  in interrupt context while taking efi_lock.
> 
>  Also, efi_pstore creates sysfs entries ,which enable users to access to NVRAM, in a write callback.
>  If a kernel panic happens in interrupt contexts, pstore may fail because it could sleep due to dynamic  memory allocations during
> creating sysfs entries.
> 
> To resolve the problems above, a goal of this patchset is making efivars/efi_pstore interrupt-safe.
> 
> [Patch Description]
>  Patch 1/3 efivars: Disable external interrupt while holding efivars->lock
>    This patch replaces spin_lock/spin_unlock with spin_lock_irqsave/spin_lock_irqrestore to make efivars interrupt safe
> 
>  Patch 2/3 efi_pstore: Introducing workqueue updating sysfs entries
>    This patch removes sysfs operations from write callback by introducing a workqueue updating sysfs entries
> 
>  Patch 3/3 efi_pstore: Skiping scheduling a workqueue in cases other than oops
>    This patch restricts a schedule of a workqueue in case where users erase entries or oops happen which is truly needed for users.
> 
>  drivers/firmware/efivars.c |  167 +++++++++++++++++++++++++++++++++++--------
>  include/linux/efi.h        |    3 +-
>  2 files changed, 138 insertions(+), 32 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
