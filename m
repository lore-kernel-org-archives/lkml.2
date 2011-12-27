Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1L0LhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 06:37:00 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61829 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654Ab1L0Lg6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 06:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAK-9PRBFuVQG8cvmry5wtw7d2AM0v+D1eV+YTckox1mS7K6NGw@mail.gmail.com>
References: <1324847148-20834-1-git-send-email-cvs268@gmail.com> <CAK-9PRBFuVQG8cvmry5wtw7d2AM0v+D1eV+YTckox1mS7K6NGw@mail.gmail.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Tue, 27 Dec 2011 17:06:37 +0530
Message-ID: <CAK-9PRAPTW61MWxjcwdfSWNoXhDRTgzN4WS7EM5Sr00bU8TbyQ@mail.gmail.com>
Subject: Re: [PATCH] Optimise apply_slack() for faster execution
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch reduces code complexity by:
- Eliminating the need for intermediate expires_limit and mask variables.
- Simplifying the timer-coalescing logic of discarding lesser significant bits.

This leads to smaller mod_timer() and add_timer() subroutines in which
apply_slack() is inlined. For example, on a typical x86-build, the
patch reduces the size of mod_timer() by 16 instructions.The total
mod_timer() function is 173 instructions i.e. the patch makes the
function 9% smaller. A typical ARM-build also shows similar savings.

original masking-logic:
shl    %cl,%edx
sub    $0x1,%edx
mov    %edx,-0x10(%ebp)
not    %edx
and    %esi,%edx
mov    %edx,-0x14(%ebp)

patched bitwise logic:
shrl   %cl,-0x14(%ebp)
shll   %cl,-0x14(%ebp)

Enabling function-traces shows us that the mod_timer() and add_timer()
functions are called ~1300 times every minute. Hence optimising these
functions gives us some significant improvement.

regards
ChinmayVS
