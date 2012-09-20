Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2ITVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:18:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30756 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2ITVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:18:32 -0400
Date: Thu, 20 Sep 2012 17:18:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120920211814.GB27312@konrad-lan.dumpdata.com>
References: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
 <20120919191652.GA14631@phenom.dumpdata.com>
 <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <505A7F75.8000405@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 07:46:57PM -0700, David Rientjes wrote:
> On Thu, 20 Sep 2012, Raghavendra K T wrote:
> 
> > Only problem, I find is histogram data expands dynamically (because it
> > changes). I think having static allocation of 352 bytes as suggested
> > Linus is a good idea.
> > 
> 
> Certainly, but it's a different topic and would be a subsequent patch to 
> either my patch or Konrad's patch.  Before that's done, I think we should 
> fix the race condition that currently exists either by:
> 
>  - merging my patch (which I can sign-off and write a changelog for if
>    Konrad agrees), or

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
>  - merging Konrad's patch and introducing a mutex so that it's possible to 
>    do many reads to collect statistics after opening the file a single 
>    time with a single fd.
> 
> Since these files are incapable of doing lseek, it would seem that my 
> patch would be best and you'd simply want to close() + open() to read new 
> data, which also guarantees that all readers get the same information.  

Yup.
> The only reason I hesitate on that and will defer to Konrad's opinion is 
> because the way the code is currently written looks like it was intended 
> to copy the data are read() rather than open(); in other words, it almost 
> seems as if they were made to be non-seekable after the u32_array_read() 
> implementation was complete and it was at one time possible to do an 
> lseek(SEEK_SET).

The "users" (looks at himself and Raghavendra) can deal with the
open/close, open/close cycle. The only thing that I would add extra is
to add the explanation you provided in the comment of the file in case
somebody expects something else.
> 
> After that's fixed, and to address your concern, we can simply do the 
> allocation of file->private_data for the maximum size possible when the 
> file is created as a follow-up patch.
