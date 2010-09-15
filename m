Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0IOTSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:18:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0IOTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=reE6PpaJWpmq+uLr0Vr+amrxpEQ4kA+I4hoJKA7c0fW7U1QY3RBAZ4gFxT0Fhb/Lew
         sng5XbkGSGpDe6F6mKzg==
MIME-Version: 1.0
In-Reply-To: <1284571473.21906.428.camel@calx>
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com>
	<201009151034.22497.knikanth@suse.de>
	<20100915141710.C9F7.A69D9226@jp.fujitsu.com>
	<201009151201.11359.knikanth@suse.de>
	<20100915140911.GC4383@balbir.in.ibm.com>
	<alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
	<1284561982.21906.280.camel@calx>
	<alpine.LNX.2.00.1009151648390.28912@zhemvz.fhfr.qr>
	<1284571473.21906.428.camel@calx>
Date: Wed, 15 Sep 2010 12:18:29 -0700
X-Google-Sender-Auth: 7GeDc6IFNNNIUbxvlbBwLnpIIkU
Message-ID: <AANLkTimYQgm6nKZ4TantPiL4kmUP9FtMQwzqeetVnGrr@mail.gmail.com>
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are
 reported clean in smaps
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:24 AM, Matt Mackall <mpm@selenic.com> wrote:

> But that's my point: the consistency problem is NOT in smaps. The page
> is NOT marked dirty, ergo smaps doesn't report it as dirty. Whether or
> not there is MORE information smaps could be reporting is irrelevant,
> the information it IS reporting is consistent with the underlying VM
> data. If there's an inconsistency about what it means to be clean, it's
> either in the VM or in your head.
>
> And I frankly think it's in the VM.

I don't believe there's any problem in the VM here, we'd be having
SIGSEGVs all over if there were.

The problem is that /proc/pid/smaps exports a simplified view of the
VM, and Richard and Nikanth were hoping that it gave them some info
which it has never pretended to give them,

It happens to use a pte_dirty(ptent) test: you could argue that that
should be pte_dirty(ptent) || PageDirty(page) (which would then "fix
the issue" which Richard sees with swapoff/swapon), or you could argue
that it should be pte_dirty(ptent) || PageDirty(page) ||
PageSwapCache(page) (which would then note clean copies of swap cache
as dirty in the sense which Richard and Nikanth are interested in).

But after these years, we should probably assume that most users of
/proc/pid/smaps are used to the existing pte_dirty(ptent) test, and
would be troubled by a departure from it.

>
> In any case, I don't think Nikanth's fix is the right fix, as it
> basically says "you can't trust any of this". Either swap should return
> the pages to their pre-swap dirty state in the VM, or we should add
> another field here:
>
> Weird_Anon_Page_You_Should_Pretend_Is_Private_Dirty: 8 kB

I think that the most widely useful but simple extension of
/proc/pid/smaps, that would give them the info they want, would indeed
be to counts ptes pointing to PageAnon pages and report that total on
an additional line (say, just before "Swap:"); but there's no need for
the derogatory name you propose there, "Anon:" would suit fine!

The original idea of testing for vma->anon_vma was a good one, but it
doesn't fit so well into the /proc/pid/smaps layout; and showing the
actual count of Anon pages could be useful to others (though generally
it would be Anon+Swap they'd be interested in).

Hugh
