Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab1DZWoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:44:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61081 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1DZWoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SYM4BruGf3DSJHZCgjEwJlcJaomC6BL6pkQr9uWYOgIxxLK9wa4ys7fPqcRxU5444u
         a6e3ueU2PZUjX4VPX8ZfWLTHsfD6uu7WN30MONa1ZyeDAhuR70VJAyKPS36iCq6zL/0M
         DOR5SbERisv90xQbB0DNnZZEHM9r5mjewkhXc=
MIME-Version: 1.0
In-Reply-To: <20110426211321.EC7513E1886@tassilo.jf.intel.com>
References: <20110426212.641772347@firstfloor.org>
	<20110426211321.EC7513E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 18:44:05 -0400
X-Google-Sender-Auth: ajbqGRrR1RqfzFUJeaCc7uRDuIw
Message-ID: <BANLkTikH1DCGKR=iE4ch9hQQihzhyn0e+g@mail.gmail.com>
Subject: Re: [PATCH] [42/106] x86, microcode, AMD: Extend ucode size verification
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: bp@amd64.org, greg@kroah.com, borislav.petkov@amd.com, stable@kernel.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 5:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.

Minor nit, but git am complains about whitespace in this backport.  I checked
the original, and at a glance it looks OK in this respect.

(42/106) Applying: x86, microcode, AMD: Extend ucode size verification
/home/paul/git/stable/linux-2.6.35.y/.git/rebase-apply/patch:95: space
before tab in indent.
 		return NULL;
/home/paul/git/stable/linux-2.6.35.y/.git/rebase-apply/patch:100:
trailing whitespace.
	
warning: 2 lines add whitespace errors.

Paul.

>
> ------------------
>
> From: Borislav Petkov <borislav.petkov@amd.com>
>
> Upstream commit: 44d60c0f5c58c2168f31df9a481761451840eb54
>
> The different families have a different max size for the ucode patch,
> adjust size checking to the family we're running on. Also, do not
> vzalloc the max size of the ucode but only the actual size that is
> passed on from the firmware loader.
>
> Cc: <stable@kernel.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  arch/x86/kernel/microcode_amd.c |   63 +++++++++++++++++++++++++++-------------
>  1 file changed, 44 insertions(+), 19 deletions(-)
>
> Index: linux-2.6.35.y/arch/x86/kernel/microcode_amd.c
> ===================================================================
> --- linux-2.6.35.y.orig/arch/x86/kernel/microcode_amd.c
> +++ linux-2.6.35.y/arch/x86/kernel/microcode_amd.c
> @@ -66,7 +66,6 @@ struct microcode_amd {
>        unsigned int                    mpb[0];
>  };
>
> -#define UCODE_MAX_SIZE                 2048
>  #define UCODE_CONTAINER_SECTION_HDR    8
>  #define UCODE_CONTAINER_HEADER_SIZE    12
>
> @@ -125,6 +124,37 @@ static int get_matching_microcode(int cp
>        return 1;
>  }
>
> +static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
> +{
> +       struct cpuinfo_x86 *c = &cpu_data(cpu);
> +       unsigned int max_size, actual_size;
> +
> +#define F1XH_MPB_MAX_SIZE 2048
> +#define F14H_MPB_MAX_SIZE 1824
> +#define F15H_MPB_MAX_SIZE 4096
> +
> +       switch (c->x86) {
> +       case 0x14:
> +               max_size = F14H_MPB_MAX_SIZE;
> +               break;
> +       case 0x15:
> +               max_size = F15H_MPB_MAX_SIZE;
> +               break;
> +       default:
> +               max_size = F1XH_MPB_MAX_SIZE;
> +               break;
> +       }
> +
> +       actual_size = buf[4] + (buf[5] << 8);
> +
> +       if (actual_size > size || actual_size > max_size) {
> +               pr_err("section size mismatch\n");
> +               return 0;
> +       }
> +
> +       return actual_size;
> +}
> +
>  static int apply_microcode_amd(int cpu)
>  {
>        u32 rev, dummy;
> @@ -162,11 +192,11 @@ static int get_ucode_data(void *to, cons
>  }
>
>  static void *
> -get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
> +get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
>  {
> -       unsigned int total_size;
> +       unsigned int actual_size = 0;
>        u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
> -       void *mc;
> +       void *mc = NULL;
>
>        if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
>                return NULL;
> @@ -176,23 +206,18 @@ get_next_ucode(const u8 *buf, unsigned i
>                return NULL;
>        }
>
> -       total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
> -
> -       if (total_size > size || total_size > UCODE_MAX_SIZE) {
> -               pr_err("error: size mismatch\n");
> +       actual_size = verify_ucode_size(cpu, buf, size);
> +       if (!actual_size)
>                return NULL;
> -       }
>
> -       mc = vmalloc(UCODE_MAX_SIZE);
> -       if (mc) {
> -               memset(mc, 0, UCODE_MAX_SIZE);
> -               if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
> -                                  total_size)) {
> -                       vfree(mc);
> -                       mc = NULL;
> -               } else
> -                       *mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
> -       }
> +       mc = vmalloc(actual_size);
> +       if (!mc)
> +               return NULL;
> +
> +       memset(mc, 0, actual_size);
> +       get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
> +       *mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
> +
>        return mc;
>  }
>
> @@ -258,7 +283,7 @@ generic_load_microcode(int cpu, const u8
>                unsigned int uninitialized_var(mc_size);
>                struct microcode_header_amd *mc_header;
>
> -               mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
> +               mc = get_next_ucode(cpu, ucode_ptr, leftover, &mc_size);
>                if (!mc)
>                        break;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
