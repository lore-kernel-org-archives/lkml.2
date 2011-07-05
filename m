Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1GEOxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:53:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36087 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab1GEOx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110701.153633.267893668051099806.davem@davemloft.net>
References: <1308708650-25509-1-git-send-email-loke.chetan@gmail.com>
	<1308708650-25509-2-git-send-email-loke.chetan@gmail.com>
	<20110701.153633.267893668051099806.davem@davemloft.net>
Date: Tue, 5 Jul 2011 10:53:26 -0400
Message-ID: <CAAsGZS5vvmb_qX+cG507=hU_+kwnowEEojXGNMt5ShEZ9+ZeAA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next af-packet 1/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: chetan loke <loke.chetan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 6:36 PM, David Miller <davem@davemloft.net> wrote:
> From: Chetan Loke <loke.chetan@gmail.com>
> Date: Tue, 21 Jun 2011 22:10:49 -0400
>
>> +struct bd_v1 {
>  -
>> +     __u32   block_status;
>> +     __u32   num_pkts;
>> +     __u32   offset_to_first_pkt;
>  -
>> +     __u32   blk_len;
>  -
>> +     __u64   seq_num;
>  ...
>> +     union {
>> +             struct {
>> +                     __u32   words[4];
>> +                     __u64   dword;
>> +             } __attribute__ ((__packed__));
>> +             struct bd_v1 bd1;
>  ...
>> +#define BLOCK_STATUS(x)      ((x)->words[0])
>> +#define BLOCK_NUM_PKTS(x)    ((x)->words[1])
>> +#define BLOCK_O2FP(x)                ((x)->words[2])
>> +#define BLOCK_LEN(x)         ((x)->words[3])
>> +#define BLOCK_SNUM(x)                ((x)->dword)
>

Sorry, I was out on the long weekend. So couldn't get to this sooner.

> This BLOCK_SNUM definition is buggy.  It modifies the
> first 64-bit word in the block descriptor.
>
> But the sequence number lives 16 bytes into the descriptor.

hmm? the words/dword are enveloped within a 'struct'. Can you please
double check?

>
> This value is only written to once and never used by anything.
> I would just remove it entirely.
>

It is used by the applications. Look at the code comments:
	/*
	 * Quite a few uses of sequence number:
	 * 1. Make sure cache flush etc worked.
	 *    Well, one can argue - why not use the increasing ts below?
	 *    But look at 2. below first.
	 * 2. When you pass around blocks to other user space decoders,
	 *    you can see which blk[s] is[are] outstanding etc.
	 * 3. Validate kernel code.
	 */


> Next, having this overlay thing is entirely pointless.  Just refer to

It is useful.
Also, future versions of the block-descriptor can append a new field.
When that happens,
none of the code needs to worry about the version etc for the unchanged fields.
Look at setsockopt - I had to add an 'union' and pass that around to
avoid minimal code churn.
So the overlay may not be pointless.

> the block descriptor members directly!  You certainly wouldn't have
> had this sequence number bug if you had done that.
>
Look at the sample app posted on:
git://lolpcap.git.sourceforge.net/gitroot/lolpcap/lolpcap

function - void validate_blk_seq_num(struct block_desc *pbd)

This function validates the block_sequence_number (which is
incremented sequentially).
The application attempts to validate the entire block layout.


Chetan Loke
