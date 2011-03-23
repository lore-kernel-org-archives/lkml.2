Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1CWHxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:53:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54984 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1CWHxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=nh7VfZefCPv2tBIBVDz250YVvwP+k/KSdHjTkMK1eymcEu6wsF7xVpFEtI8SXsjL6+
         +gaP5tBf0VVt9khm1c6Iv/7YwxkmlyplvH+ZMlDgW9vSe3GApeZvE4qSSDHof3RrTTg3
         XmaQcZgYRb5tqbq10xgq5Ptz1KzwXTK4ppZ+A=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110323062939.GJ15270@dastard>
References: <1300793023-3775-1-git-send-email-david@fromorbit.com>
	<AANLkTimi97y2=t8srkgOpfjt7WF5ZroR_W=0mGpEgE96@mail.gmail.com>
	<20110323062939.GJ15270@dastard>
Date: Wed, 23 Mar 2011 08:53:19 +0100
Message-ID: <AANLkTikyFVRuXMvnvSqgcQacJVAZtSXq+CgXowDOw2pL@mail.gmail.com>
Subject: Re: vfs: inode lock breakup
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 7:29 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Mar 22, 2011 at 07:17:04PM +0100, Sedat Dilek wrote:
>> On Tue, Mar 22, 2011 at 12:23 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > Hi Al,
>> >
>> > The following patches are the inode_lock breakup series originally
>> > derived from Nick Piggin's vfs-scale tree. I've kind of been sitting
>> > on them until the dcache_lock breakup and rcu path-walk has had some
>> > time to be shaken out. The patch ѕet is pretty much unchanged from
>> > the last round of review last last year - all I've done to bring it
>> > up to date is forward port it and run it through some testing on XFS
>> > and ext4.
>> >
>> > I know it's late in the .39 merge window, but I hope you'll consider
>> > it if the patches are still acceptable(*). Otherwise I'm happy to take
>> > the time to get it right for .40.
>> >
>> > Cheers,
>> >
>> > Dave.
>> >
>> > (*) The series can also be found here:
>> >
>> >  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git inode-scale
>> >
>> > Dave Chinner (8):
>> >      fs: protect inode->i_state with inode->i_lock
>> >      fs: factor inode disposal
>> >      fs: Lock the inode LRU list separately
>> >      fs: remove inode_lock from iput_final and prune_icache
>> >      fs: move i_sb_list out from under inode_lock
>> >      fs: move i_wb_list out from under inode_lock
>> >      fs: rename inode_lock to inode_hash_lock
>> >      fs: pull inode->i_lock up out of writeback_single_inode
>> >
>> [...]
>>
>> Hi,
>>
>> I have tested this patch-series on top of linux-next (next-20110322)
>> by running xfstests-dev (built from git).
>>
>> My sdb2 partition (on an external 1GBytes USB-2.0 hdd) was formatted
>> and mounted as ext4-fs .
>
> If you really want to use xfstests to produce some system stress,
> you'd do better to use an XFS filesystem ;)
>

First, I was riddling why I could not install xfstests-dev to an
individual $PREFIX and waste(?) some time into looking into the
configure* files - dbtest.c failed building by not setting correct
$libgdbm (normal build via make is OK).
Then I saw the hardcoded /var/lib/ as INSTALL_PATH... and didn't
wanted dig deeper.
I overflew the README, but that file needs a bit of more hints.

I can do some XFS testing if you wish.
The numbers in the result say nothing to me as I can't compare them
with other systems.
It's like putting the hand in a glass of water and wild speculating
the temperature.
You can say cold or warm if you have a 2nd glass with different temperature.

So, it might be worth to add a file (name: benchmark.txt?) with some results?

>> The check-log is attached (not sure how to interpret the errors and failures).
>
> Nothing indicates an unknown failure...
>
>> 001 5s ... 4s
>> 002 1s ... 1s
>> 003    [not run] not suitable for this filesystem type: ext4
>> 004    [not run] not suitable for this filesystem type: ext4
>> 005    - output mismatch (see 005.out.bad)
>> --- 005.out   2011-03-22 17:47:03.861226933 +0100
>> +++ 005.out.bad       2011-03-22 18:47:58.847277538 +0100
>> @@ -1,7 +1,7 @@
>>  QA output created by 005
>>  *** touch deep symlinks
>>
>> -ELOOP returned.  Good.
>> +No ELOOP?  Unexpected!
>>
>>  *** touch recusive symlinks
>
> This is a result of Al fixing the max nested loop depth very early
> on in .39, so the test needs to run to deeper nesting depths to
> produce ELOOP. So it's a test problem, not a bug.
>
>> 197    [not run] not suitable for this filesystem type: ext4
>> 198    [failed, exit status 127] - output mismatch (see 198.out.bad)
>> --- 198.out   2011-03-22 17:47:03.917226229 +0100
>> +++ 198.out.bad       2011-03-22 19:04:12.591035920 +0100
>> @@ -1,2 +1,3 @@
>>  QA output created by 198
>>  Silence is golden.
>> +./198: line 54: /home/sd/src/xfstests-dev/xfstests-dev/src/aio-dio-regress/aiodio_sparse2: No such file or directory
>
> You need to install libaio and friends so that the binary is
> built. We probably need to add a "requires_aio" test option to
> detect this situation and not_run the test gracefully.
>

Yupp, the build-/configure-system could be enhanced in that case.
(I add "Notes to myself" see my P.S. to remember what I did and what I missed.)

>> 238    [not run] not suitable for this filesystem type: ext4
>> 239    [not run] src/aio-dio-regress/aio-dio-hole-filling-race not built
>
> Like this one does....
>
>> 240    [failed, exit status 127] - output mismatch (see 240.out.bad)
>> --- 240.out   2011-03-22 17:47:03.925226129 +0100
>> +++ 240.out.bad       2011-03-22 19:04:59.866441589 +0100
>> @@ -1,2 +1,3 @@
>>  QA output created by 240
>>  Silence is golden.
>> +./240: line 72: /home/sd/src/xfstests-dev/xfstests-dev/src/aio-dio-regress/aiodio_sparse2: No such file or directory
>
> Same again.
>
>> 241    [not run] dbench not found
>> 242    [not run] not suitable for this filesystem type: ext4
>> 243 3s ... 3s
>> 244    [not run] not suitable for this filesystem type: ext4
>> 245 0s ... 0s
>> 246 0s ... 0s
>> 247 77s ... 78s
>> 248 0s ... 0s
>> 249 0s ... 1s
>> 250    [not run] not suitable for this filesystem type: ext4
>> 251    [not run] this test requires a valid $SCRATCH_DEV
>> Ran: 001 002 005 006 007 010 011 013 014 070 074 075 088 089 126 127 131 133 184 198 213 214 215 221 225 228 236 237 240 243 245 246 247 248 249
>> Not run: 003 004 008 009 012 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 060 061 062 063 064 065 066 067 068 069 071 072 073 076 077 078 079 080 081 082 083 084 085 086 087 090 091 092 093 094 095 096 097 098 099 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 128 129 130 132 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 185 186 187 188 189 190 191 192 193 194 195 196 197 199 200 201 202 203 204 205 206 207 208 209 210 211 212 216 217 218 219 220 222 223 224 226 227 229 230 231 232 233 234 235 238 239 241 242 244 250 251
>> Failures: 005 198 240
>> Failed 3 of 35 tests
>
> A typical XFS run gives:
>
> Ran: 001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 019 020 021 026 027 028 029 030 031 032 033 034 041 042 045 046 047 048 049 050 051 052 053 054 056 061 062 063 064 065 066 067 068 069 070 072 073 074 075 076 077 078 079 083 084 085 086 087 088 089 091 092 096 100 103 104 105 108 109 110 112 113 116 117 118 119 120 121 123 124 125 126 127 128 129 130 131 132 133 134 135 137 138 139 140 141 164 165 166 167 169 170 174 178 179 180 181 182 183 184 186 187 188 189 190 192 193 194 195 196 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250
> Not run: 035 040 044 057 058 090 093 094 095 097 098 099 122 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 168 175 176 177 185 191 197
> Failures: 189 229 250
> Failed 3 of 180 tests
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Thanks for your explanations!

BTW, are changes/updates to xfstests-dev announced somewhere (like ML)?

- Sedat -
