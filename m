Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab1IIMa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:30:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab1IIMa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:30:58 -0400
Message-ID: <4E6A0700.9030401@suse.cz>
Date: Fri, 09 Sep 2011 14:30:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.8.2011 02:37, Arnaud Lacombe wrote:
> Hi folks,
> 
> The attached patch modify Kbuild to allow to directly re-use code in multiple
> directory without having to go through a copy. Technically, it changes Kbuild to
> use by default the VPATH feature of GNU make and provides accessors for Makefile
> to change it indirectly.
> 
> Considering:
> 
> arch/foo/lib:
> fancy.c
> 
> We want to be able to build it with -DPANTS=32 in the kernel, but the
> bootloader requires -DPANTS_SIZE=30.
> 
> Currently we would do, either:
> 
> arch/foo/lib/Makefile
> LDFLAGS_fancy.o := -DPANTS=32
> obj-y += fancy.o
> 
> and, either:
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> $(obj)/fancy.c: $(srctree)/arch/foo/lib/fancy.c
> 	$(call cmd,shipped)
> 
> or
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> $(obj)/fancy.o: $(srctree)/arch/foo/lib/fancy.c
> 	$(call cmd,cc_c_o)
> 
> The former implies an extra copy of the source file, the latter expose Kbuild
> internal function.
> 
> With the attached patch, we would do:
> 
> arch/foo/boot/Makefile:
> LDFLAGS_fancy.o := -DPANTS=30
> obj-y += fancy.o
> vpath-y += $(srctree)/arch/foo/lib
> 
> and let GNU make do the job.

I like this. The only issue I can think of right now, is that if you add
a large directory to vpath-y, then it would be easy to accidentally
reuse more files from that directory than intended. But that could be
easily prevented by isolating those reusable source files.

Michal
