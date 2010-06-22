Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0FVNHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:07:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47548 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab0FVNHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:07:05 -0400
Date: Tue, 22 Jun 2010 15:08:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: intel_cacheinfo: potential NULL dereference?
Message-ID: <20100622130825.GB27658@aftab>
References: <4C209C15.9090604@gmail.com>
 <4C209C6E.3060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C209C6E.3060302@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Tue, Jun 22, 2010 at 07:20:14AM -0400

> On 06/22/2010 01:18 PM, Jiri Slaby wrote:
> > Hi,
> > 
> > commit 9350f982 changed the code so it looks like:
> > static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
> >                                    const char *buf, size_t count,
> >                                    unsigned int slot)
> > {
> >         struct pci_dev *dev = this_leaf->l3->dev;   <<1>>
> >         int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> >         unsigned long val = 0;
> > 
> > #define SUBCACHE_MASK   (3UL << 20)
> > #define SUBCACHE_INDEX  0xfff
> > 
> >         if (!this_leaf->l3 || !this_leaf->l3->can_disable)  <<2>>
> >                 return -EINVAL;
> > 
> > Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
> > for being NULL at <<2>>. Is the check superfluous or the dev assignment
> > should go after the check?
> 
> Oh, and I have another report with same symptoms for show_cache_disable.

Right, so I have a patch in tip/x86/cpu
(8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0) which reorganizes
and cleans up that code. With it, all possible checks land in
amd_check_l3_disable() and if they have all been passed, the PCI dev is
guaranteed to be properly set. So no need for sprinkling additional NULL
checks in the code.

How's that?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
