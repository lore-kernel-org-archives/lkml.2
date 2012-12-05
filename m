Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2LEL1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:27:07 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:42913 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2LEL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:26:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
References: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
Date: Wed, 5 Dec 2012 12:26:09 +0100
Message-ID: <CAF6-1L4vZ4KqJcw+HfAYQsM=UVahxE2Ls8S6OZu3izZhJvfTDA@mail.gmail.com>
Subject: Re: Wrong length / buffer overlow by the syslog syscall
From: Sylvain Munaut <s.munaut@whatever-company.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> It happens on several machines and this only seem to happen if there
> was a wrap around in the log buffer (it's a first observation on a
> limited number of sample so it might be a coincidence)

I think the culprit is print_time and has nothing to do with wrap
around, just the uptime.

static size_t print_time(u64 ts, char *buf)
{
       unsigned long rem_nsec;

       if (!printk_time)
               return 0;

       if (!buf)
               return 15;

       rem_nsec = do_div(ts, 1000000000);
       return sprintf(buf, "[%5lu.%06lu] ",
                      (unsigned long)ts, rem_nsec / 1000);
}

it assumes the time will always be 15 char which is wrong. The %5lu
only guarantees a _minimum_ length of 5 chars, but if ts is large
enough it can be 6,7,...
and indeed in my logs I see "[601678.426219] "  which is 16 chars
(includes the space at the end).

Cheers,

     Sylvain
