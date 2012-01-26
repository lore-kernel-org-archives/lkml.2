Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2AZRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:31:26 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46125 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab2AZRbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:31:25 -0500
Message-ID: <4F218D36.2060308@linux.vnet.ibm.com>
Date: Thu, 26 Jan 2012 09:28:22 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
In-Reply-To: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012617-7182-0000-0000-000000950811
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 01:58 PM, Dan Magenheimer wrote:
> (Feedback welcome if there is a different/better way to do this
> without using a page flag!)
> 
> Since about 2.6.27, the page replacement algorithm maintains
> an "active" bit to help decide which pages are most eligible
> to reclaim, see http://linux-mm.org/PageReplacementDesign 
> 
> This "active' information is also useful to cleancache but is lost
> by the time that cleancache has the opportunity to preserve the
> pageful of data.  This patch adds a new page flag "WasActive" to
> retain the state.  The flag may possibly be useful elsewhere.

I guess cleancache itself is clearing the bit, right?  I didn't see any
clearing going on in the patch.

I do think it also needs to get cleared on the way in to the page
allocator.  Otherwise:

	PageSetWasActive(page);
	free_page(page);
	...
	another_user_page = get_free_page()
	// now cleancache sees the active bit for the prev user

Or am I missing somewhere it gets cleared non-explicitly somewhere?

