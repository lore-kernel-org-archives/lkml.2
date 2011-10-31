Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1JaXpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:45:51 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63254 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1JaXpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <201111010024.16659.rjw@sisk.pl>
References: <20111031221743.GA18855@google.com>
	<201111010024.16659.rjw@sisk.pl>
Date: Mon, 31 Oct 2011 18:45:48 -0500
Message-ID: <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ@mail.gmail.com>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
From: Steve French <smfrench@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-pm@vger.kernel.org,
        linux-cifs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 6:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, October 31, 2011, Tejun Heo wrote:
>> Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
>> TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
>> sleep too citing non-interruptible but killable sleeps in cifs and
>> nfs.
>>
>> I don't think we can do this.  We should not send spurious unsolicited
>> non-interruptible wakeups.  Most synchornization constructs are built
>> to cope with spurious wakeups and any INTERRUPTIBLE sleep must be able
>> to handle spurious wakeups but that's not true for KILLABLE sleeps -
>> KILLABLE condition cannot be cancelled.
>>
>> This is probably okay for most cases but circumventing fundamental
>> wakeup condition like this is asking for trouble.  Furthermore, I'm
>> not sure the behavior change brought on by this change - breaking
>> nfs/cifs uninterruptible operation guarantee - is correct.  If such
>> behavior is desirable, the right thing to do is using intr mount
>> option, not circumventing it from PM layer.
>
> Do you have any specific examples of breakage, or is it just that you _think_
> it's not quite right?
>
> One patch depending on that change has been merged already and I have two
> more in the queue, so I'd like to clarify this ASAP.  Jeff, Steve?
>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Jeff Layton <jlayton@redhat.com>
>> ---
>> Neil, Steve, do the network filesystems need a way to indicate "I can
>> either be killed or enter freezer"?

Probably, yes, but I will defer to Jeff as he has looked
more recently at these issues.

I can explain cifs state, and disconnect/reconnection of sessions
(and smb2 is a little more feature rich in this regard), but will
let Jeff explain the more subtle points you are getting at.

-- 
Thanks,

Steve
