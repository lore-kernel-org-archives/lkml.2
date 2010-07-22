Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0GVJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:10:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59244 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVJKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eY9R+2+efj5GshJLtKP03QK7Hl6rkIxQtlm7khmsfbyMc9UMgBTNhFd37M2ehMWZUo
         5eL2uTUoT7Pcox4ZTlKa/t0m9SjNvCgO4wf5b/Ejr6hZdyHueTq7ZO9ca08UJxxU6bUz
         e/ceTKkzA7DRwFakFqsG5zj+CFseOrbM7RN0I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
	<AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
	<AANLkTikY0eeq1Ufs-UOCiHYXu_314HUnw7ESK5ktocWV@mail.gmail.com>
Date: Thu, 22 Jul 2010 10:10:39 +0100
Message-ID: <AANLkTimNFIc8Ygg4O2NPHCYHk1G3dLBhYA2N9JSeAbdt@mail.gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-ext4@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2010 02:06, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, Jul 21, 2010 at 1:43 AM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
>> Hi Luis,
>>
>> On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> I have been reluctant to boot to 2.6.35-rc due to the large set of
>>> regression list and the amount of work I needed to actually get done
>>> on 2.6.35. Last I checked the regression list it was getting small so
>>> I gave it a spin today. No luck. I get some bootup error from udevd
>>> and ext2/ext3/ext4, something like this:
>>>
>>> EXT3-fs (sda1): error: couldn't mount because of unsupported optional
>>> features (240)
>>> EXT2-fs (sda1): error: couldn't mount because of unsupported optional
>>> features (240)
>>> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
>>
>> This succeeded.
>
> Heh, OK :)
>
>>> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
>>> Freeing unused kernel memory: 708k freed
>>> Write protecting the kernel read-only data: 102040k
>>> Freeing unused kernel memory: 764k freed
>>> Freeing unused kernel memory: 1796k freed
>>> udevd: failed to create queue file: No such file or directory
>>> udevd: error creating queue file
>>
>> It looks like you need to enable:
>>
>> CONFIG_DEVTMPFS
>> CONFIG_DEVTMPFS_MOUNT
>
> Thanks, it also turned out that when I upgraded from Ubuntu 9.10 to
> Ubuntu 10.04 it replaced my own /sbin/installkernel so this was likely
> another issue. My /sbin/installkernel changes allow for easy initramfs
> installation on Debian/Ubuntu but my patches have been ignored my the
> maintainer.
>
> --- installkernel-ubuntu-10.04  2010-07-21 18:03:34.607678010 -0700
> +++ installkernel       2010-01-29 13:17:10.000000000 -0800
> @@ -36,7 +36,8 @@
>  # Create backups of older versions before installing
>  updatever () {
>   if [ -f "$dir/$1-$ver" ] ; then
> -    mv "$dir/$1-$ver" "$dir/$1-$ver.old"
> +    #mv "$dir/$1-$ver" "$dir/$1-$ver.old"
> +    rm -f "$dir/$1-$ver" "$dir/$1-$ver.old"
>   fi
>
>   cat "$2" > "$dir/$1-$ver"
> @@ -75,5 +76,16 @@
>  if [ -f "$config" ] ; then
>   updatever config "$config"
>  fi
> +
> +LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
> +
> +case $LSB_RED_ID in
> +"Ubuntu")
> +       update-initramfs -c -k  $ver
> +       update-grub
> +       ;;
> +*)
> +       ;;
> +esac
>
>  exit 0
>
> But anyway I also now get another boot failure with:
>
> mount: mounting /dev on /root/dev failed: No such file or directory
> mount: mounting /sys on /root/sys failed: No such file or directory

Hmm...the scripts in the initrd are not doing what is expected -
perhaps if you didn't use:
linux$ fakeroot make-kpkg --append-to-version -luis1 --initrd kernel-image

...or if there are eg initrd script modifications on the filesystem
when it cooked the initd.

You could just try eg:
http://archive.ubuntu.com/ubuntu/pool/main/l/linux/linux-image-2.6.35-9-generic_2.6.35-9.14_amd64.deb

...although it will regenerate it's initrd, so may suffer the same fate.

> http://bombadil.infradead.org/~mcgrof/images/2010/bleh-boot-2.6.35-rc5.jpg
>
>  Luis
-- 
Daniel J Blueman
