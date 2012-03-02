Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2CBOau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:30:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33910 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2CBOat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:30:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.68.135.71 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330698646.2469.28.camel@edumazet-laptop>
Subject: Re: 3.3.0-rc5: OOps in dql_completed (Broadcom tg3 driver)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Herbert <therbert@google.com>
Date: Fri, 02 Mar 2012 06:30:46 -0800
In-Reply-To: <alpine.DEB.2.00.1203011505510.6685@router.home>
References: <alpine.DEB.2.00.1203011505510.6685@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 mars 2012 à 15:13 -0600, Christoph Lameter a écrit :
> Dell R620. 2x 2.9Ghz Sandybridge
> 
> Sadly I could only get a screenshot and the top of the dump has scrolled
> off the system.
> 

Thanks Christoph for this report.

Tom, dql_queued() assumes caller checked availability in the queue with
dql_avail(), but its not the case if tg3_tso_bug() is called.

        do {
                nskb = segs;
                segs = segs->next;
                nskb->next = NULL;
                tg3_start_xmit(nskb, tp->dev);
        } while (segs);

In case we hit BQL limit in one of the tg3_start_xmit() calls, we should
'abort' the following ones, dont you think ?

Or maybe thats irrelevant, and only dql_queued() comment is wrong.

Thanks


