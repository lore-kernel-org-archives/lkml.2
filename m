Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1AOTEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:04:04 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:35889 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AOTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:04:01 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 15 Jan 2011 11:03:59 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Shawn Bohrer <shawn.bohrer@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Jack Stone <jwjstone@fastmail.fm>, Viresh Kumar <viresh.kumar@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/3] epoll: remove unnecessary test of ep->ovflist for
 available events
In-Reply-To: <1295110837-3061-3-git-send-email-shawn.bohrer@gmail.com>
Message-ID: <alpine.DEB.2.00.1101150938090.6884@davide-lnx1>
References: <20110115162027.GA2552@lintop> <1295110837-3061-3-git-send-email-shawn.bohrer@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jan 2011, Shawn Bohrer wrote:

> The additional test for ep->ovflist != EP_UNACTIVE_PTR to signify
> available events was added in 5071f97ec6d74f006072de0ce89b67c8792fe5a1
> but doesn't appear to do anything.  Either this is a bug or the check
> isn't needed.
> 
> If the ep->ovflist is not EP_UNACTIVE_PTR then ep_send_events() calls
> ep_scan_ready_list() which sets ep->ovflist = NULL thus loosing any
> events which may have been stored there.
> 
> Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>

NACK. Not only NACK, but hell NACK.
The epoll_wait() might hit right after the delivery of the current events 
ended in/right-after:

	error = (*sproc)(ep, &txlist, priv);

So, if there are overflowed events, a following ep_send_events() can go 
fetch them, because ep_scan_ready_list() will go drop them back in the 
ready list (right after the line above).
Events in the overflow list are no different from the ones in the ready 
list, and removing such test will make you, either return with no events 
when they are really there, or take another unnecessary spin lock/unlock 
trip.
On the contrary, a missed optimization is applying the same rule even 
above, instead of the bare list_empty(). Will send a patch to Andrew.
And no, it is not a bug, because ep_scan_ready_list() is protected by a 
mutex.
	


- Davide


