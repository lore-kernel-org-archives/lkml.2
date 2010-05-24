Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0EXOvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:51:44 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:51720 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752208Ab0EXOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:51:43 -0400
Message-ID: <4BFA927A.8070305@athenacr.com>
Date: Mon, 24 May 2010 10:51:38 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <E1OEmP5-0006GU-KC@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.1005190946540.23538@i5.linux-foundation.org> 	<AANLkTikkRywJSJ8HFsVhVU9dHz8cFGqlK9ZHXZuGQbb2@mail.gmail.com> 	<20100522223838.ebca396a.akpm@linux-foundation.org> <AANLkTinFOqDF0v_uMvkj4r8n4aX4xvpFvTi-9odUYa5F@mail.gmail.com> 	<20100523070917.GO23411@kernel.dk> <AANLkTimKFHQPi9kKhYYjRhMt0s5CDsBXmESQaH493hpR@mail.gmail.com> 	<20100523174706.GP23411@kernel.dk> <87632e846m.fsf@devron.myhome.or.jp> 	<20100524070416.GQ23411@kernel.dk> <AANLkTikwTa16lDh87zkI-L9SaI9jG1_eqZuo4z7dj2qP@mail.gmail.com>
In-Reply-To: <AANLkTikwTa16lDh87zkI-L9SaI9jG1_eqZuo4z7dj2qP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 03:28 AM, Michael Kerrisk wrote:
> Actually, SO_*BUF is pretty weird. It returns double what was
> supplied. It's not simply a matter of rounding up: it always doubles
> what was supplied.

Rationale in net/core/sock.c:

set_rcvbuf:
                sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
                /*
                 * We double it on the way in to account for
                 * "struct sk_buff" etc. overhead.   Applications
                 * assume that the SO_RCVBUF setting they make will
                 * allow that much actual data to be received on that
                 * socket.
                 *
                 * Applications are unaware that "struct sk_buff" and
                 * other overheads allocate from the receive buffer
                 * during socket buffer allocation.
                 *
                 * And after considering the possible alternatives,
                 * returning the value we actually used in getsockopt
                 * is the most desirable behavior.
                 */
                if ((val * 2) < SOCK_MIN_RCVBUF)
                        sk->sk_rcvbuf = SOCK_MIN_RCVBUF;
                else
                        sk->sk_rcvbuf = val * 2;
                break;

I'm guessing pipes don't have this kind of wrinkle.

