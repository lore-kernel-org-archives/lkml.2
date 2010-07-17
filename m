Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0GQF3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 01:29:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0GQF3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 01:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n96lFIodlW+C2iMQvhXTckA6z+a4iufov8/ltmLFzboG9exSw0R0VDCM7BCi3lcoXp
         EDQvGIYnuKIAoLbnY/y8IqsAPK/x6vSLCHmuwGw6EZh75K2fMwUS3A3Gnkeqj48lbq1W
         bVuYRtuRtvO4xfHC80tCsskxmKEA6nt5b4XDk=
MIME-Version: 1.0
In-Reply-To: <20100714194905.GA20286@infradead.org>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
	<20100714194905.GA20286@infradead.org>
Date: Sat, 17 Jul 2010 07:29:00 +0200
Message-ID: <AANLkTik2T53BeDl7KWZEixVqXbZ1IajkQlTHBO41Qj2V@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6H5TaGG029933

On Wed, Jul 14, 2010 at 9:49 PM, Christoph Hellwig <hch@infradead.org> wrote:
> There are a lot of variables when using qemu.
>
> The most important one are:
>
>  - the cache mode on the device.  The default is cache=writethrough,
>   which is not quite optimal.  You generally do want to use cache=none
>   which uses O_DIRECT in qemu.
>  - if the backing image is sparse or not.
>  - if you use barrier - both in the host and the guest.
>
> Below I have a table comparing raw blockdevices, xfs, btrfs, ext4 and
> ext3.  For ext3 we also compare the default, unsafe barrier=0 version
> and the barrier=1 version you should use if you actually care about
> your data.
>
> The comparism is a simple untar of a Linux 2.6.34 tarball, including a
> sync after it.  We run this with ext3 in the guest, either using the
> default barrier=0, or for the later tests also using barrier=1.  It
> is done on an OCZ Vertext SSD, which gets reformatted and fully TRIMed
> before each test.
>
> As you can see you generally do want to use cache=none and every
> filesystem is about the same speed for that - except that on XFS you
> also really need preallocation.  What's interesting is how bad btrfs
> is for the default compared to the others, and that for many filesystems
> things actually get minimally faster when enabling barriers in the
> guest.  Things will look very different for barrier heavy guest, I'll
> do another benchmark for those.
>
>                                                        bdev            xfs             btrfs           ext4            ext3            ext3 (barrier)
>
> cache=writethrough      nobarrier       sparse          0m27.183s       0m42.552s       2m28.929s       0m33.749s       0m24.975s       0m37.105s
> cache=writethrough      nobarrier       prealloc        -               0m32.840s       2m28.378s       0m34.233s       -               -
>
> cache=none              nobarrier       sparse          0m21.988s       0m49.758s       0m24.819s       0m23.977s       0m22.569s       0m24.938s
> cache=none              nobarrier       prealloc        -               0m24.464s       0m24.646s       0m24.346s       -               -
>
> cache=none              barrier         sparse          0m21.526s       0m41.158s       0m24.403s       0m23.924s       0m23.040s       0m23.272s
> cache=none              barrier         prealloc        -               0m23.944s       0m24.284s       0m23.981s       -               -
>
Very interesting. I haven't had the time to try it again, but now I'm
gonna try some options about the cache and see what gives me the best
results.

-- 
Giangiacomo
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
