Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1CXXpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:45:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab1CXXpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h6CSU72FPhsEfm+qVScuPPuGmQcD/qeUptcrieXtt7wIiaA1cuJMH4yIYtyBnDwBGR
         IGWV3hEdn2rdcL2mw6KA==
MIME-Version: 1.0
In-Reply-To: <20110324174311.GA31576@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
Date: Thu, 24 Mar 2011 16:45:40 -0700
Message-ID: <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
From: Michel Lespinasse <walken@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sean Noonan <Sean.Noonan@twosigma.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:43 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Michel,
>
> can you take a look at this bug report?  It looks like a regression
> in your mlock handling changes.

I had a quick look and at this point I can describe how the patch will
affect behavior of this test, but not why this causes a deadlock with
xfs.

The test creates a writable, shared mapping of a file that does not
have data blocks allocated on disk, and also uses the MAP_POPULATE
flag.

Before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272, make_pages_present
during the mmap would cause data blocks to get allocated on disk with
an xfs_vm_page_mkwrite call, and then the file pages would get mapped
as writable ptes.

After 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272, make_pages_present
does NOT cause data blocks to get allocated on disk. Instead,
xfs_vm_readpages is called, which (I suppose) does not allocate the
data blocks and returns zero filled pages instead, which get mapped as
readonly ptes. Later, the test tries writing into the mmap'ed block,
causing minor page faults, xfs_vm_page_mkwrite calls and data block
allocations to occur.


Regarding the deadlock: I am curious to see if it could be made to
happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
what happens if you remove the MAP_POPULATE flag from your mmap call,
and instead read all pages from userspace right after the mmap ? I
expect you would then be able to trigger the deadlock before
5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.


This leaves the issue of the change of behavior for MAP_POPULATE on
ftruncated file holes. I'm not sure what to say there though, because
MAP_POPULATE is documented to cause file read-ahead (and it still does
after 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272), but that doesn't say
anything about block allocation.


Hope this helps,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
