Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1JKNCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:02:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39342 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1JKNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:02:20 -0400
X-AuditID: b753bd60-a16a6ba000005c89-28-4e943e5a8a91
X-AuditID: b753bd60-a16a6ba000005c89-28-4e943e5a8a91
Message-ID: <4E943E53.6010601@hitachi.com>
Date: Tue, 11 Oct 2011 22:02:11 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH net 1/2] [BUGFIX] bonding: use local function pointer
 of bond->recv_probe in bond_handle_frame
References: <20111007124925.7089.27260.stgit@ltc219.sdl.hitachi.co.jp> <20111007124954.7089.9776.stgit@ltc219.sdl.hitachi.co.jp> <CAM_iQpXZmX2GPb99tF7xMEup52o8AfeUi+0awvHr7C9LVWTjEg@mail.gmail.com>
In-Reply-To: <CAM_iQpXZmX2GPb99tF7xMEup52o8AfeUi+0awvHr7C9LVWTjEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG Cong

Thank you for your comments.

(2011/10/07 22:24), Américo Wang wrote:
> On Fri, Oct 7, 2011 at 8:49 PM, Mitsuo Hayasaka
> <mitsuo.hayasaka.hu@hitachi.com> wrote:
>> The bond->recv_probe is called in bond_handle_frame() when
>> a packet is received, but bond_close() sets it to NULL. So,
>> a panic occurs when both functions work in parallel.
>>
>> Why this happen:
>> After null pointer check of bond->recv_probe, an sk_buff is
>> duplicated and bond->recv_probe is called in bond_handle_frame.
>> So, a panic occurs when bond_close() is called between the
>> check and call of bond->recv_probe.
>>
>> Patch:
>> This patch uses a local function pointer of bond->recv_probe
>> in bond_handle_frame(). So, it can avoid the null pointer
>> dereference.
>>
> 
> Hmm, I don't doubt it can fix the problem, I am wondering if
> bond->recv_probe should be protected by bond->lock...

Indeed, in general any resources should be protected from the asynchronous
workers.

At first, I thought it should be handled with lock protection, as well.
However, I guess that using bond->lock on this kind of hot-path may
introduces unnecessary overhead. In addition, this code works well
without the strict lock protection. So, I think this change is the
right way to fix it.

Thanks.
