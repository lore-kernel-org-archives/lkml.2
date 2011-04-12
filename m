Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1DLUXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:23:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370Ab1DLUXc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:23:32 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
References: <BANLkTin3gtiBk8nvsWEiJetKHq2+9HTi4w@mail.gmail.com>
 <BANLkTimJLcfsYAhV+3=-F14YZvX12-yXgA@mail.gmail.com> <20110412182809.GA1218@redhat.com>
 <BANLkTinb1gXcZug5ApmmrudWLY7PwxNf-A@mail.gmail.com> <20110412192059.GA14360@redhat.com>
 <BANLkTimJgx_x=0bpBDWaUkJgZPYs3_iwsg@mail.gmail.com> <BANLkTimBegMUq2fX67o2YnoATWG-NDbKgA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 13:22:39 -0700
Message-ID: <BANLkTikoDELrA-RtA9BLm64mfoPgdADR0Q@mail.gmail.com>
Subject: Re: Processes hang in an unkillable state
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 1:03 PM, Robert Święcki <robert@swiecki.net> wrote:
>>
>> Ok, applied Linus' patch and got the following (kdb dump in the attachment):
>>
>> It contains references to sys_mlock, but in another process/user that
>> oopsed (there are iknowthis and iknowthis2 processes running under
>> test and test2 users). I think I'll simply disable sys_madvise in the
>> fuzzer; and treat this oops as a separate issue.

This does seem to be something else.

It looks like some kind of live-lock situation between two processes
both doing madvise() and causing vmtruncate_range() calls.

Miklos wrote this patch for something bad in this area to serialize
concurrent unmap_mapping_range() calls in order to not restart forever
on vm_truncate_count. That got merged into 2.6.38, so it's there, but
I wonder if there is some case it misses.

                           Linus
