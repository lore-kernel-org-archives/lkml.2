Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2ALVUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:20:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56125 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab2ALVT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:19:57 -0500
Date: Thu, 12 Jan 2012 13:19:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, lizf@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
In-Reply-To: <CAOJsxLEYY=ZO8QrxiWL6qAxPzsPpZj3RsF9cXY0Q2L44+sn7JQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201121309340.17287@chino.kir.corp.google.com>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com> <20120111141219.271d3a97.akpm@linux-foundation.org> <1326355594.1999.7.camel@lappy> <CAOJsxLEYY=ZO8QrxiWL6qAxPzsPpZj3RsF9cXY0Q2L44+sn7JQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, Pekka Enberg wrote:

> I think you missed Andrew's point. We absolutely want to issue a
> kernel warning here because ecryptfs is misusing the memdup_user()
> API. We must not let userspace processes allocate large amounts of
> memory arbitrarily.
> 

I think it's good to fix ecryptfs like Tyler is doing and, at the same 
time, ensure that the len passed to memdup_user() makes sense prior to 
kmallocing memory with GFP_KERNEL.  Perhaps something like

	if (WARN_ON(len > PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
		return ERR_PTR(-ENOMEM);

in which case __GFP_NOWARN is irrelevant.  I think memdup_user() should 
definitely be taking gfp flags, though, so the caller can specify things 
like __GFP_NORETRY on its own to avoid infinitely looping in the page 
allocator trying reclaim and possibly calling the oom killer.
