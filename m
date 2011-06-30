Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1F3Vzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56489 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1F3Vzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:33 -0400
Subject: Re: [PATCH v3 8/9] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309361388-30163-9-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:54:27 +0200
Message-ID: <1309470867.12449.605.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
> +       return __touch_steal_time(is_idle, UINT_MAX, NULL);

That wants to be ULLONG_MAX, because max_steal is a u64, with UINT_MAX
the comparison:

+               if (steal > max_steal)

Isn't true per-se and the compiler cannot optimize the branch away.
Also, make sure it does indeed optimize that branch away, otherwise
simply duplicate the code. This is on the very hottest scheduler paths,
branches do count.

Same for:

+               if (ticks)

with ticks == NULL, make sure it never emits code for the above call.

Ah, also, all that requires you strip that noinline crap you put on it,
if it cannot inline, it cannot assume anything on the input and will
this have to emit all this nonsense.


