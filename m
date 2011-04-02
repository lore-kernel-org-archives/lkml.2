Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1DBOGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 10:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1DBOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 10:06:49 -0400
Date: Sat, 2 Apr 2011 16:06:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110402140628.GB26316@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D96052D.3030902@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D96052D.3030902@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Stas Sergeev wrote:
> Hi Oleg.
>
> This time, the child is allowed to disappear from parent's
> radar in case the old parent was slow to wait(),

Hmm... Again, I didn't really read the patch... But iiuc, the
detached child can exit and init can reap it, after that the
old parent gets ECHLD?

You know, even if the patch was correct and this feature was
acked, I'd try to nack this ;) do_wait() from parent should
always work or it should always return ECHLD, but it should
not depend on /dev/random. This is really weird, imho.

OK, even ignoring prctl() code he patch is buggy. __unhash_process()
does list_del_init(&p->detached_sibling). This is too late. If the
old parent has already called wait_task_detached() and cleared
->detaching, this child will add the unnecessary cost to every
subsequent do_wait() call. If the old parent exits, list_del_init()
can crash the kernel.

I didn't read the patch further.

Oleg.

