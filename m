Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0JaKIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 06:08:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37553 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab0JaKIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 06:08:38 -0400
Date: Sun, 31 Oct 2010 11:08:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Peter Oruba <peter.oruba@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        amd64-microcode@amd64.org
Subject: Re: [PATCH] AMD Microcode: Prefer vzalloc() over calls to
 vmalloc()+memset()
Message-ID: <20101031100833.GA18633@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Peter Oruba <peter.oruba@amd.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	amd64-microcode@amd64.org
References: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1010302118160.1572@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 09:23:14PM +0200, Jesper Juhl wrote:
> We don't have to do memset() ourselves after vmalloc() when we have 
> vzalloc(), so change that in 
> arch/x86/kernel/microcode_amd.c::get_next_ucode().
> 
> Please CC me on replies.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> compile tested only.
> 
>  microcode_amd.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index e1af7c0..d46e805 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -183,9 +183,8 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
>  		return NULL;
>  	}
>  
> -	mc = vmalloc(UCODE_MAX_SIZE);
> +	mc = vzalloc(UCODE_MAX_SIZE);
>  	if (mc) {
> -		memset(mc, 0, UCODE_MAX_SIZE);
>  		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
>  				   total_size)) {
>  			vfree(mc);

Good.

Better yet, you can go a step further and remove one indentation block:

--
	mc = vzalloc(UCODE_MAX_SIZE);
	if (!mc)
		goto out;

	if (get_ucode_data(mc, ...
	...

out:
	return mc;

}
--
making the code even fit in 80 chars width and thus more readable.

Thanks.

-- 
Regards/Gruss,
    Boris.
