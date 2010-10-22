Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0JVKDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:03:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:45697 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0JVKDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:03:43 -0400
Date: Fri, 22 Oct 2010 19:03:30 +0900
To: tj@kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4CBD95DC.8000001@kernel.org>
References: <4CBD95C0.6060302@kernel.org>
	<4CBD95DC.8000001@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101022185701H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 Oct 2010 19:03:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 14:58:04 +0200
Tejun Heo <tj@kernel.org> wrote:

> SCSI is the only subsystem which uses execute_in_process_context().
> With the recent workqueue updates, unconditionally using work wouldn't
> cause deadlocks around execution resources and the two places where
> SCSI uses them are cold paths where using work unconditionally
> wouldn't make any difference.  Drop execute_in_process_context() and
> use work directly.
> 
> * scsi_device->ew is replaced with release_work.  scsi_target->ew is
>   replaced with reap_work.
> 
> * Both works are initialized with the respective release/reap function
>   during device/target init.  scsi_target_reap_usercontext() is moved
>   upwards to avoid needing forward declaration.
> 
> * scsi_alloc_target() now explicitly flushes the reap_work of the
>   found dying target before putting it instead of depending on
>   flush_scheduled_work().
> 
> This is in preparation of deprecation of flush_scheduled_work() and
> execute_in_process_context().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/scsi_scan.c   |   26 +++++++++++++-------------
>  drivers/scsi/scsi_sysfs.c  |    8 +++++---
>  include/scsi/scsi_device.h |    4 ++--
>  3 files changed, 20 insertions(+), 18 deletions(-)

Looks fine to me.
