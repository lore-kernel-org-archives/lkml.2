Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1A0RtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:49:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35507 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1A0RtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SHpcEfCIQE000CuktyN/SsWpnK5JgPMOFW91/YAa3TrRZiOjMLgQcVS99hObLY3AZ1
         FS/zsHewFOzI4Q+VU6Kfa8c9YZa6DtnCYp1ffYW+jlZwSB1Gj46PHbfXpr01QAJBrP23
         9PgDeToahXfhYgyWJTJiknJgmPNZP2THba348=
Date: Thu, 27 Jan 2011 18:48:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110127174857.GG24925@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021417.D347A1807B7@magilla.sf.frob.com>
 <20110127154600.GE24925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127154600.GE24925@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 27, 2011 at 04:46:00PM +0100, Tejun Heo wrote:
> On Mon, Jan 17, 2011 at 06:14:17PM -0800, Roland McGrath wrote:
> > Oh, and for any kind of ptrace changes, please always run the whole
> > ptrace-tests suite before and after.  That is by no means an exhaustive
> > test that you haven't introduced new problems.  But if you introduce
> > regressions in that suite, it is quite like that you are causing problems
> > for existing ptrace users like gdb (even if some tests were racy before,
> > if the real-world practical results change, it could be a problem).
> > 
> > http://sourceware.org/systemtap/wiki/utrace/tests has the pointers.
> 
> Alright, will try to do that.

Okay, just finished ran make check with and without the patchset.
Without the patchset, 2.6.38-rc2 failed five tests.  With the patchset
six.  The one extra test which failed was attach-sigcont-wait because
the tracee now always enters TRACED after PTRACE_ATTACH, which I think
is the correct behavior because the previous behavior where a stopped
task honors SIGCONT unconditionally if it was delivered before the
next ptrace call (any operation other than detach) doesn't make any
sense to me in addition to the fact that it was buggy regarding the
arch hook.

Is there an actual use case which requires this behavior?  We can try
to emulate the original behavior but I don't think it's a sane one.

Another difference was how stopped-detach-sleeping failed.  It failed
both with and without the patchset but with the patchset it triggered
an assert().  The difference was because the assert() was testing
whether the task was in STOPPED state after attach - it's now in
TRACED state instead.  With the assert removed, it failed the same
way.

Thanks.

-- 
tejun
