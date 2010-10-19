Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab0JSUMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:12:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57040 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0JSUMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=qok1VGPlIiB2PWuCOPOniJ2J5FAS0QIvb9UM/Gg0rSn8PxwlorRcrfpqVv0FVzKM+c
         2FQoeqKOZFkyhcee5RKtdEOihIQCZcJX21VDWjtynqohnP1bL5t5i77VgxEOlojoM8FT
         l+EQOkEtdfEdGpsCNWsw/ByYR+SaiVY2LD6qA=
MIME-Version: 1.0
In-Reply-To: <20101019110801.GA4128@linux.vnet.ibm.com>
References: <20100831082307.064687027@linux.vnet.ibm.com> <20100831083844.043619334@linux.vnet.ibm.com>
 <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Oct 2010 16:11:53 -0400
Message-ID: <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, mmarek@suse.cz,
        Sam Ravnborg <sam@ravnborg.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 07:08, Hendrik Brueckner wrote:
> --- a/usr/Makefile
> +++ b/usr/Makefile
> @@ -19,6 +19,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
>  suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
>
>  AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
> +ifdef CONFIG_SYMBOL_PREFIX
> +AFLAGS_initramfs_data.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> +endif
>
>  # Generate builtin.o based on initramfs_data.o
>  obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o

i dont think we want to go this route.  keep it in one place:
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -120,7 +120,9 @@ _c_flags += $(if $(patsubst n%,, \
 endif

 ifdef CONFIG_SYMBOL_PREFIX
-_cpp_flags += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+_sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+_cpp_flags += $(_sym_flags)
+_a_flags += $(_sym_flags)
 endif


-mike
