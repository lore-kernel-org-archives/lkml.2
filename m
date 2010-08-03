Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0HCLCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:02:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40335 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab0HCLCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:02:13 -0400
Date: Tue, 3 Aug 2010 06:59:41 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH V2] core_pattern: fix long parameters was truncated
 by core_pattern handler
Message-ID: <20100803105941.GA2996@hmsreliant.think-freely.org>
References: <20100729130707.GA31154@shamino.rdu.redhat.com>
 <1280751836-1826-1-git-send-email-dfeng@redhat.com>
 <20100802135013.GA5877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802135013.GA5877@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 03:50:13PM +0200, Oleg Nesterov wrote:
> 
> Also. Not sure this really makes sense, but if we ever need to expand the
> string, perhaps it makes sense to remeber this fact so that the next time
> we start with len > CORENAME_MAX_SIZE. In any case, I think this needs a
> separate patch.
> 
> Oleg.

Yes, this is what I alluded to in my initial reply.  We need to keep an atomic
value to track the maximum number of times we've called expand_corename to help
prevent us having to call it repeatedly on every crash.  Something like this:

expand_corename(**corename, **out_end, **out_ptr)
{
	...
	*corename = krealloc(*corename,
			     CORENAME_MAX_SIZE*
			     atomic_inc_return(call_count),
			     GFP_KERNEL);
	...
}


do_coredump(...)
{
	...
	corename = kmalloc(CORENAME_MAX_SIZE *
			   atomic_read(call_count),
			   GFP_KERNEL);
	...
}


That will train the path to allocate a sensible size after the first crash, and
avoid lots of calls to krealloc in the pessimal case

Neil

