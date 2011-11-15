Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1KOCxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:53:54 -0500
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:58469 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab1KOCxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:53:52 -0500
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Nov 2011 21:53:52 EST
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 14 Nov 2011 20:36:48 -0600
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Topic: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Index: AcyjP20fOl97gDZQQYmLzzSoKWIRPA==
Message-ID: <4A0007C2-1C2C-4162-98E8-ACCA4E673AFE@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
 <20111110165455.GE11983@schlenkerla.am.freescale.net>
 <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
 <1320986410.21206.48.camel@pasglop>
In-Reply-To: <1320986410.21206.48.camel@pasglop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2011, at 23:40, Benjamin Herrenschmidt wrote:
> On Thu, 2011-11-10 at 18:38 -0600, Moffett, Kyle D wrote:
>>  (2) Make the ppc64_caches struct apply to ppc32 as well, and
>>      preinitialize it with a minimum value used by any platform being
>>      compiled in (for "dcbXX"/"icbXX" purposes).  This is safe because
>>      the pagesize is always a multiple of the cache block size and the
>>      kernel only uses dcbXX/icbXX on whole pages.  The only impact is a
>>      temporary small performance hit from flushing or zeroing the same
>>      block 8 times if too small.
> 
> Are you sure about dcbz ? Getting that wrong can be deadly ... I'd
> rather get rid of some fancy optims and use a soft value in some cases.
> That or we can compile multiple variants for the common case of some of
> the copy routines and use patching (alternate sections) to branch to the
> right one at runtime, at least for the common cases (32 and 128 for
> example for 440 and 476).

Well, all of the kernel loops that use dcbz are operating on whole pages,
and the PPC Book-E spec documents that the pagesize is an even multiple
of the cacheline size and the cachelines are always page-aligned.

So when you are clearing a whole page, there are only 2 things you can do
wrong with "dcbz":

  (1) Call "dcbz" with an address outside of the page you want to zero.

  (2) Omit calls "dcbz" to dcbz for some physical cachelines in the page.

Now, that's a totally different story from the userspace memset() calls
that caused the problem originally, because they were frequently given
memory much smaller than a page to clear, and if you didn't know exactly
how many bytes a "dcbz" was going to clear you couldn't use it at all.

But the kernel doesn't do that anywhere, it just uses it for page clears.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

