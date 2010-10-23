Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0JWRkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:40:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab0JWRku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:40:50 -0400
Date: Sat, 23 Oct 2010 10:40:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: A question on block_prepare_write()
Message-Id: <20101023104036.2bec05a0.akpm@linux-foundation.org>
In-Reply-To: <1287841482.1681.36.camel@leonhard>
References: <1287841482.1681.36.camel@leonhard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010 22:44:42 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Hello,
> 
> I see block_prepare_write() has local variable wait[2] to keep track of
> buffer_heads which are not up-to-date. But I'm wondering how it could be
> guaranteed there will be no more than 2 such buffer_heads? Is there any
> restriction on the usage of the function? Using MAX_BUF_PER_PAGE instead
> of the magic number 2 is just useless? I couldn't find any comments or
> documentation on this.
> 
> Any of your comments would be greatly appreciated. TIA. :-)
> 

block_prepare_write() may need to preread any buffer_head which are
being only partially modified by the write().

Buffers which aren't being modified at all don't need to be preread. 
Buffers which are being fully modified don't need to be preread
(because all their data is being overwritten).

page:                      |-----------------------|
buffer_heads:              |-----|-----|-----|-----|
area we're writing to:               |---------|

There can only be a maximum of two partially-modified buffers in the page.
