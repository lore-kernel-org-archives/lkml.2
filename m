Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1K1KkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:40:05 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:54610 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1K1KkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <1322474116.2292.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1321866845.3831.7.camel@lappy>
	<1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111128181446.2ab784d0@kryten>
	<1322474116.2292.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Mon, 28 Nov 2011 12:40:01 +0200
X-Google-Sender-Auth: C7ZqyMvNeVIHj4HdXtDYRstDeLw
Message-ID: <CAEnQRZBxjCUByhEb3TfZEwVxkGY-uDKYr_Yavfr+TLx-TPoxrA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix corruption in /proc/*/net/dev_mcast
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, Anton Blanchard <anton@samba.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, David Miller <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> dev_mc_seq_ops uses dev_seq_start/next/stop but only allocates
>> sizeof(struct seq_net_private) of private data, whereas it expects
>> sizeof(struct dev_iter_state):
>>
>> struct dev_iter_state {
>>       struct seq_net_private p;
>>       unsigned int pos; /* bucket << BUCKET_SPACE + offset */
>> };
>>
>> Create dev_seq_open_ops and use it so we don't have to expose
>> struct dev_iter_state.

Good catch, indeed! We've now checked and this is the only place
where the problem happens.


>> +int dev_seq_open_ops(struct inode *inode, struct file *file,
>> +                  const struct seq_operations *ops)
>> +{
>> +     return seq_open_net(inode, file, ops, sizeof(struct dev_iter_state));
>> +}

Perhaps you could use this function also in dev_seq_open (dev.c:4280).

>>  static int dev_mc_seq_open(struct inode *inode, struct file *file)
>>  {
>> -     return seq_open_net(inode, file, &dev_mc_seq_ops,
>> -                         sizeof(struct seq_net_private));
>> +     return dev_seq_open_ops(inode, file, &dev_mc_seq_ops);
>>  }
>>
>>  static const struct file_operations dev_mc_seq_fops = {


thanks,
Daniel.
