Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0LLWsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:48:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:40390 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0LLWsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:48:40 -0500
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
From: James Bottomley <James.Bottomley@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4CBD95DC.8000001@kernel.org>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 16:48:33 -0600
Message-ID: <1292194113.2989.9.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 14:58 +0200, Tejun Heo wrote:
> SCSI is the only subsystem which uses execute_in_process_context().
> With the recent workqueue updates, unconditionally using work wouldn't
> cause deadlocks around execution resources and the two places where
> SCSI uses them are cold paths where using work unconditionally
> wouldn't make any difference.  Drop execute_in_process_context() and
> use work directly.

Sorry, managed to lose this until the ping.

The analysis above isn't quite correct, I'm afraid.  We use the
execute_in_process_context() not to avoid deadlocks, but to acquire
process context if we don't have it because the API allows calling from
sites at interrupt context.  The point of using
execute_in_process_context() is that we actually want to make use of the
user context if we have one ... there's no point using a workqueue in
that case, because there's nothing to be gained (except to slow
everything down).  We have no ordering constraints (the traditional
reason for using workqueues) so this is purely about context.

Alan stern recently did an analysis (at least for the target reap) that
says we actually have no interrupt context call sites, so abandoning the
execute_in_process_context() for a direct call in that case might make
sense.

James


