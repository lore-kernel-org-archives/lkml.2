Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab1LOWjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:39:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab1LOWi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <20111215141945.add405d5.akpm@linux-foundation.org>
References: <1323917052-480-1-git-send-email-walken@google.com>
	<20111215141945.add405d5.akpm@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:38:58 -0800
Message-ID: <CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I think the patch is correct but the description is misleading?
>
> I see no memory leak here.  Calling __putname() directly simply
> bypasses some audit-related stuff.

Hmmm, maybe I wasn't explicit enough about it. We are definitely
seeing a memory leak without the patch.

When auditing is enabled, putname() calls audit_putname *instead* (not
in addition) to __putname(). Then, if a syscall is in progress,
audit_putname does not release the name - instead, it expects the name
to get released when the syscall completes, but that will happen only
if audit_getname() was called previously, i.e. if the name was
allocated with getname() rather than the naked __getname(). So,
__getname() followed by putname() ends up leaking memory.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
