Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1DGKXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:23:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56943 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1DGKXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZgsrDlb70YEfEAg5XGba9Gici9kf99W7X0iKfq2Zn/MCFgPHAisqGtqy2p9GTThtv0
         CpNJxB+2fZ+P7fWUxlQgaum5ferwgKRAMTwbv8RkgSKVmhSBLUr8LfVlkvhSzK/C0Drb
         HNF4o79wNU8gTkD+QXO7B5oXRWlfpi+fYeiM0=
MIME-Version: 1.0
In-Reply-To: <20110407095646.GA30788@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
Date: Thu, 7 Apr 2011 18:23:07 +0800
Message-ID: <BANLkTimXRcKyWdUxS2TRzibcSUdCfObH3g@mail.gmail.com>
Subject: Re: dynamic oldmem in kdump kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 5:56 PM, Olaf Hering <olaf@aepfle.de> wrote:
>
> Recently kdump for pv-on-hvm Xen guests was implemented by me.
>
> One issue remains:
> The xen_balloon driver in the guest frees guest pages and gives them
> back to the hypervisor. These pages are marked as mmio in the
> hypervisor. During a read of such a page via the /proc/vmcore interface
> the hypervisor calls the qemu-dm process. qemu-dm tries to map the page,
> this attempt fails because the page is not backed by ram and 0xff is
> returned. All this generates high load in dom0 because the reads come
> as 8byte requests.
>
> There seems to be no way to make the crash kernel aware of the state of
> individual pages in the crashed kernel, it is not aware of memory
> ballooning. And doing that from within the "kernel to crash" seems error
> prone. Since over time the fragmentation will increase, it would be best
> if the crash kernel itself queries the state of oldmem pages.
>
> If copy_oldmem_page() would call a function, a hook, provided by the Xen
> pv-on-hvm drivers to query if the pfn to read from is really backed by
> ram the load issue could be avoided. Unfortunately, even Xen needs to
> get a new interface to query the state of individual hvm guest pfns for
> the purpose mentioned above.

This makes sense for me, we might need a Xen-specific copy_oldmem_page()
hook and a native hook.

>
> Another issue, slightly related, is memory hotplug.
> How is this currently handled for kdump?  Is there code which
> automatically reconfigures the kdump kernel with the new memory ranges?
>

No, the crashkernel memory is reserved during boot, and it is static after
that (except you can shrink this memory via /sys). Kdump isn't aware of
memory hotplug.

Thanks.
