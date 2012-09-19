Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2ISXU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:20:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35941 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2ISXU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:20:28 -0400
Date: Wed, 19 Sep 2012 16:20:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
In-Reply-To: <CA+55aFzU1S6cybghVv4Bg2K8X1NC2pX2XebSrEgn0pKtgyCfRw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1209191608160.17867@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com> <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <CA+55aFzU1S6cybghVv4Bg2K8X1NC2pX2XebSrEgn0pKtgyCfRw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012, Linus Torvalds wrote:

> That does look simpler, and avoiding the lock is a good idea. Since we
> don't support lseek() (or pread/pwrite) on that thing anyway, there's
> no way to keep the fd open and just re-use it to read the data over
> and over, so populating it at open time sounds like a good solution
> with no real downsides.
> 

Yeah, my patch is functionally the same as what we currently have with the 
only exception being that it isn't racy.  I'm wondering if that's what we 
really want, though, since the data read from the file will remain 
persistent as long as it is opened.  That obviously happens in my patch 
because we allocate and copy the buffer at open(), but also happens 
implicitly with the old code precisely because it's a non-seekable file 
and *ppos == 0 only once (when not racy).

So if the API for these xen files is to remain persistent after open() as 
it currently does, then my patch solves the issue.  However, if the API 
wants to allow to only open() once and then read the spinlock_stats data 
continuously, then we'll need the mutex: allocate the file->private_data 
buffer once at open() for the maximum allowable size and then copy to the 
buffer from xen's spinlock_stats under the protection of the mutex to 
read().

Konrad?
