Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1JLHEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:04:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50106 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1JLHEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:04:53 -0400
X-AuditID: b753bd60-9e4a1ba000005c89-20-4e953c122061
X-AuditID: b753bd60-9e4a1ba000005c89-20-4e953c122061
Message-ID: <4E953C0C.9020107@hitachi.com>
Date: Wed, 12 Oct 2011 16:04:44 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH net 1/2] [BUGFIX] bonding: use local function pointer
 of bond->recv_probe in bond_handle_frame
References: <20111007124925.7089.27260.stgit@ltc219.sdl.hitachi.co.jp>  <20111007124954.7089.9776.stgit@ltc219.sdl.hitachi.co.jp>  <CAM_iQpXZmX2GPb99tF7xMEup52o8AfeUi+0awvHr7C9LVWTjEg@mail.gmail.com>  <4E943E53.6010601@hitachi.com> <1318339433.2538.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1318339433.2538.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thank you for your comment.

(2011/10/11 22:23), Eric Dumazet wrote:
> Le mardi 11 octobre 2011 à 22:02 +0900, HAYASAKA Mitsuo a écrit :
>> Hi WANG Cong
>>
>> Thank you for your comments.
>>
>> (2011/10/07 22:24), Américo Wang wrote:
>>> On Fri, Oct 7, 2011 at 8:49 PM, Mitsuo Hayasaka
>>> <mitsuo.hayasaka.hu@hitachi.com> wrote:
>>>> The bond->recv_probe is called in bond_handle_frame() when
>>>> a packet is received, but bond_close() sets it to NULL. So,
>>>> a panic occurs when both functions work in parallel.
>>>>
>>>> Why this happen:
>>>> After null pointer check of bond->recv_probe, an sk_buff is
>>>> duplicated and bond->recv_probe is called in bond_handle_frame.
>>>> So, a panic occurs when bond_close() is called between the
>>>> check and call of bond->recv_probe.
>>>>
>>>> Patch:
>>>> This patch uses a local function pointer of bond->recv_probe
>>>> in bond_handle_frame(). So, it can avoid the null pointer
>>>> dereference.
>>>>
>>>
>>> Hmm, I don't doubt it can fix the problem, I am wondering if
>>> bond->recv_probe should be protected by bond->lock...
>>
>> Indeed, in general any resources should be protected from the asynchronous
>> workers.
>>
>> At first, I thought it should be handled with lock protection, as well.
>> However, I guess that using bond->lock on this kind of hot-path may
>> introduces unnecessary overhead. In addition, this code works well
>> without the strict lock protection. So, I think this change is the
>> right way to fix it.
> 
> Maybe, but then ACCESS_ONCE() is needed to prevent compiler to
> 'optimize' the temporary variable.
> 
> Or use rcu_dereference() to make the whole thing really safe and self
> documented.
> 
I agreed.
I'd like to send the patch with ACCESS_ONCE(), again.

Thanks.
