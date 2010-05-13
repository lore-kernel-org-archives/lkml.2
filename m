Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0EMTIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:08:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35426 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab0EMTIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:08:35 -0400
Message-ID: <4BEC4E17.3090206@zytor.com>
Date: Thu, 13 May 2010 12:08:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com>
In-Reply-To: <201005131256.17997.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 11:56 AM, Bjorn Helgaas wrote:
> 
> I'm a little bit nervous about Linux's current strategy of assigning
> resources to things before we even know whether we're going to use
> them.  We don't support dynamic PCI resource reassignment, so maybe
> we don't have any choice in this case, but generally I prefer the
> lazy approach.
> 

Lazy has its own pitfalls.  In particular, the issue here is about
allocation of bridge devices, which may cause all kinds of issues with
bridges further up.  Consider:


	       A
	      / \
             B   C
             |   |
             D   E

... where A, B, and C are bridges, and D and E are devices.  Now the
driver initializes D, and requests address space.  As a result, the OS
configures bridge B to have a 4K window, and accordingly the same for
bridge A.

Now you want to initialize device E.  This means the window for bridge A
has to be widened, because bridge C is going to need its own 4K window.
 If the linearly consecutive address space is not available, it now
means reconfiguring bridge B and device D.

4K granularity really hurts.  It made sense when bridges were relatively
rare, but in PCI-express world that is no longer the case...

	-hpa
