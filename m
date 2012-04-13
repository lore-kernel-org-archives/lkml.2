Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2DMOhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:37:15 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:38389 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2DMOhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:37:13 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 13 Apr 2012 10:37:00 -0400
Subject: RE: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Topic: [PATCH] efi: Avoid sysfs spew on reboot and panic
Thread-Index: Acz8tGq+4nNVR+eHR66m28fsQhx58Aczlnkg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E4BE64480@USINDEVS01.corp.hds.com>
References: <32727E9A83EE9A42A1F0906295A3A77B2E598C0A91@USINDEVS01.corp.hds.com>
In-Reply-To: <32727E9A83EE9A42A1F0906295A3A77B2E598C0A91@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1204130132
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

Do you have any comment on this patch?

Seiji

> -----Original Message-----
> From: Seiji Aguchi
> Sent: Wednesday, March 07, 2012 5:50 PM
> To: linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); Chen Gong (gong.chen@linux.intel.com); Matthew Garrett
> (mjg@redhat.com); dzickus@redhat.com
> Cc: dle-develop@lists.sourceforge.net; Satoru Moriya
> Subject: [PATCH] efi: Avoid sysfs spew on reboot and panic
> 
> Hi,
> 
> This patch just modified Matthew's patch which has not included in upstream to fit current upstream code.
> 
> https://lkml.org/lkml/2011/9/20/468
> 
>  Right now all pstore accesses to efivars will delete or create new sysfs  nodes. This is less than ideal if we've panicked or rebooting for
> following reasons.
>   - efi_pstore may not work if kernel panics in interrupt context, since
>     cpu can sleep while creating sysfs files.
>   - we don't need to create sysfs if we've panicked or rebooting, because
>     no one can access to it.
> 
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/firmware/efivars.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index d25599f..34c8890 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -550,6 +550,16 @@ static int efi_pstore_write(enum pstore_type_id type,
> 
>  	spin_unlock(&efivars->lock);
> 
> +	/*
> +	 * If it's more severe than KMSG_DUMP_OOPS then we're already dead.
> +	 * Don't bother playing with sysfs.
> +	 */
> +
> +	if (reason != KMSG_DUMP_OOPS) {
> +		*id = part;
> +		return ret;
> +	}
> +
>  	if (found)
>  		efivar_unregister(found);
> 
> -- 1.7.1
