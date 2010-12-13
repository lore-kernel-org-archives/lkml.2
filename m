Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab0LMRnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:43:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41168 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab0LMRni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=LxLKuQtN0+v3UpFIn9i7SWvosAPE15mhiTd6yDqOtFL8K8Oo73QLaYD9O0DKJL2PAh
         1aLppvCkcgIrwf/S9dlXNyONMw8jNAbdv14Js8mpeQK6z5opKoumOLGAQrPEJX2PEyrF
         VeWD0o3xzRUBF+e0152Hel4Xje6wKpibohNlg=
Date: Mon, 13 Dec 2010 15:43:30 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213174330.GC7417@ghostprotocols.net>
References: <20101212201613.GA1784@nowhere>
 <4D06301C.2090309@cisco.com>
 <20101213155451.GA1691@nowhere>
 <20101213164854.GL5407@ghostprotocols.net>
 <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
 <20101213171537.GC1691@nowhere>
 <1292260699.6803.305.camel@twins>
 <20101213172216.GB7417@ghostprotocols.net>
 <1292261716.6803.332.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292261716.6803.332.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 13, 2010 at 06:35:16PM +0100, Peter Zijlstra escreveu:
> On Mon, 2010-12-13 at 15:22 -0200, Arnaldo Carvalho de Melo wrote:
> > > No, the last one already happened, you cannot postpone the last one,
> > > there will always be another excuse.
> > 
> > Did you understand the use case? How to have multiple reference times
> > when appending?
> 
> Yes, I understood it perfectly, I just detest the existence of these
> pure user records, they need to die ASAP.

Heck, that was be the first I suggested to introduce ;-)
 
> > "last one" means adding a multiplexor, PERF_RECORD_LAST_ONE if you will,
> > and inside it we add new events if the need arises. Then never again we
> > add a PERF_RECORD_ event in userspace. 
> 
> Nah, that sucks too, the whole concept of pure user-space events in that
> stream sucks.
> 
> There's multiple things you can do, you could:
> 
>  - create a kernel event PERF_RECORD_NEW_BUFFER and stuff that into each
> fresh buffer when its created, it could contain all kinds of 1-time
> information, like:
> 	* this CLOCK_MONOTONIC offset (for what little good that does, since
> our clock isn't strictly sync'ed to CLOCK_MONOTONIC so we can incur
> arbitrary drift).
>  	* architecture details, like 64/32 host info needed for the
> PERF_SAMPLE_REGS stuff.
> 
>  - extend the existing header infrastructure to write a new header in
> front of the new stream. The main header already has a data section that

Ok, so for this specific case its just a matter of s/event/header/g ?
:-)

I.e. just add a new header when appending and have the size of the
"sessions" in each header? Fine with me as well, the information will be
at the same place I intended, i.e. before each recording session.

> points to the end of the stream, add a continuation header section that
> points to a continuation-header used to appends and record the clock
> offset data in there.
> 
>  - something else entirely.
> 
> Just stop using these stupid fake events and be somewhat creative.

Whatever, never introduced one, they are inserted, IIRC, in the
beggining of the stream, so I guess we can just do that sed and call
them headers and be done with it.

Will verify if that is the case.

- Arnaldo
