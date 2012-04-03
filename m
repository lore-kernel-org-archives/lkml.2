Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2DCTX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:23:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55818 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DCTX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120402.203442.1793134339535157754.davem@davemloft.net>
References: <20120402.203442.1793134339535157754.davem@davemloft.net>
Date: Tue, 3 Apr 2012 21:23:55 +0200
Message-ID: <CAPVoSvTbqyEuDD5icKhXYJX-W+chfgOXchhtab7p6B9z-hCYGg@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 2:34 AM, David Miller <davem@davemloft.net> wrote:
> 7) virtio_net accidently uses net_ratelimit() not only on the kernel
>   warning but also the statistic bump, fix from Rick Jones.

I just saw this commit land in Linus tree and I think its got its
parentheses wrong.

Old code (minus the dev_warn()-messages):
if (net_ratelimit()) {
  if (likely(capacity == -ENOMEM)) {
    dev_warn(...);
  } else {
    dev->stats.tx_fifo_errors++;
    dev_warn(...);
  }
}

New code (minus the dev_warn()-messages):
if (likely(capacity == -ENOMEM)) {
  if (net_ratelimit()) {
    dev_warn(...);
  } else {
    dev->stats.tx_fifo_errors++;
    if (net_ratelimit())
      dev_warn(...);
  }
}

Now it will count -ENOMEM errors that were not logged..

I think, intended was:
if (likely(capacity == -ENOMEM)) {
  if (net_ratelimit()) {
    dev_warn(...);
  }
} else {
  dev->stats.tx_fifo_errors++;
  if (net_ratelimit())
    dev_warn(...);
}

HTH, Torsten
