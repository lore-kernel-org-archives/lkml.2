Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3ADWed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:34:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38146 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ADWeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
Date: Fri, 4 Jan 2013 14:34:28 -0800
X-Google-Sender-Auth: YyLraEk9AiSVuxU1fqmYwpozSKM
Message-ID: <CAE9FiQUPJixU2e0T2DWJN1Uz5zLYJPzWZRryqG388d7A1Me6LQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 2:26 PM, Shuah Khan <shuahkhan@gmail.com> wrote:

> However, I think regression on existing behavior with a
> panic is a bit of a big hammer. Thie change causes panic on systems
> even when kdump is not enabled, if I understand it correctly.

I don't think so.

+static bool __init enough_mem_for_swiotlb(void)
+{
+       /* do we have less than 1M RAM under 4G ? */
+       return memblock_mem_size(1ULL<<(32-PAGE_SHIFT)) > (1ULL<<20);
+}

enough_mem_for_swiotlb could return false for them?

and

 int __init pci_swiotlb_detect_override(void)
 {
-       int use_swiotlb = swiotlb | swiotlb_force;
-
        if (swiotlb_force)
                swiotlb = 1;
+       else if (!enough_mem_for_swiotlb())
+               swiotlb = 0;

-       return use_swiotlb;
+       return swiotlb;
 }

it only disable swiotlb when there is less 1M mem under 4G.
