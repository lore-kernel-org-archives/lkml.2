Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1DLS6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:58:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45645 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1DLS6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:58:46 -0400
Date: Tue, 12 Apr 2011 20:58:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, mstowe@redhat.com,
        dnelson@redhat.com, tony.luck@intel.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for
 corrected errors
Message-ID: <20110412185842.GB9891@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
	dzickus@redhat.com, mstowe@redhat.com, dnelson@redhat.com,
	tony.luck@intel.com
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 01:44:05PM -0400, Prarit Bhargava wrote:
> Don't display the "human readable" warning for correctable errors in mce.
> There is no need for this information to be displayed.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Why not? This way you turn reporting of _ALL_ correctable MCEs
completely off and some users would actually like to run them through
mcelog on Intel.

> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 450a366..8024013 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -100,10 +100,16 @@ ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
>  EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
>  
>  static int default_decode_mce(struct notifier_block *nb, unsigned long val,
> -			       void *data)
> +			      void *data)
>  {
> -	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
> -	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
> +	struct mce *m = (struct mce *)data;
> +
> +	if (m->status & MCI_STATUS_UC) {
> +		pr_emerg(HW_ERR "No human readable MCE decoding support "
> +			 "on this CPU type.\n");
> +		pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' "
> +			 "to decode.\n");
> +	}
>  
>  	return NOTIFY_STOP;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
