Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2A2U4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:56:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35410 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2A2U4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <1327805865.2805.23.camel@edumazet-laptop>
References: <CAB0C5qK1FGc5xhGxGzpmELbWfC6GVVxEB9Zan_nU9cC_MxMzew@mail.gmail.com>
	<1327805865.2805.23.camel@edumazet-laptop>
Date: Sun, 29 Jan 2012 15:56:41 -0500
Message-ID: <CAB0C5qLhUL6fKcZsjmfs1At8wWk7vQhpXOdk0S85fxypiW28Og@mail.gmail.com>
Subject: Re: [PATCH 001/001] net: Add tx_queue/rx_queue info to /proc/net/unix
From: Ryan Hajdaj <rhajdaj@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acknowledged, unix_diag (ss command) addresses the need for this patch.
- Ryan

On 1/28/12, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 28 janvier 2012 à 21:37 -0500, Ryan Hajdaj a écrit :
>> From: Ryan Hajdaj <rhajdaj@gmail.com>
>>
>> Add tx_queue/rx_queue info to /proc/net/unix (unix_seq_show)
>>
>> Signed-off-by: Ryan Hajdaj <rhajdaj@gmail.com>
>> Tested-by: Ryan Hajdaj <rhajdaj@gmail.com>
>> ---
>> tx_queue/rx_queue info is useful in systems with multiple processes
>> using Unix Domain sockets to communicate, as it can be used to check
>> process health "at a glance".
>> Unit tested on Unix stream and datagram sockets.
>> --- linux-3.3-rc1/net/unix/af_unix.c.orig	2012-01-28 20:36:33.000000000
>> +0000
>> +++ linux-3.3-rc1/net/unix/af_unix.c	2012-01-28 19:09:18.000000000 +0000
>> @@ -2286,13 +2286,14 @@ static int unix_seq_show(struct seq_file
>>
>>  	if (v == SEQ_START_TOKEN)
>>  		seq_puts(seq, "Num       RefCount Protocol Flags    Type St "
>> -			 "Inode Path\n");
>> +			 "tx_queue rx_queue Inode Path\n");
>>  	else {
>>  		struct sock *s = v;
>>  		struct unix_sock *u = unix_sk(s);
>>  		unix_state_lock(s);
>>
>> -		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
>> +		seq_printf(seq,
>> +			"%pK: %08X %08X %08X %04X %02X %08lX %08lX %5lu",
>>  			s,
>>  			atomic_read(&s->sk_refcnt),
>>  			0,
>> @@ -2301,6 +2302,8 @@ static int unix_seq_show(struct seq_file
>>  			s->sk_socket ?
>>  			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTED : SS_UNCONNECTED) :
>>  			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
>> +			unix_outq_len(s),
>> +			(unix_inq_len(s) < 0 ? 0 : unix_inq_len(s)),
>>  			sock_i_ino(s));
>>
>>  		if (u->addr) {
>
> You missed some discussion on netdev about this kind of patches.
>
> /proc/net/unix format is frozen.
>
> Pavel Emelyanov did the work to support unix_diag, where you can find
> all you need.
>
>
>
>
