Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1GZUo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1GZUo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:44:26 -0400
Message-ID: <4E2F270C.7020100@redhat.com>
Date: Tue, 26 Jul 2011 14:43:56 -0600
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ian Lance Taylor <iant@google.com>,
        gcc-help@gcc.gnu.org, stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>	<1311618747.3526.32.camel@gandalf.stny.rr.com>	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>	<1311625197.3526.35.camel@gandalf.stny.rr.com>	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>	<CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>	<mcrfwltoov5.fsf@coign.corp.google.com>	<CACqU3MXuMDz46rM9p_7iBeK1G0T-DH=52KHj9ygc42j=qQmP4g@mail.gmail.com>	<1311642766.3526.60.camel@gandalf.stny.rr.com> <CACqU3MXysWUYNnNQniR5LB4x1UGhJqwoYnTFmj=U8do-qRghow@mail.gmail.com>
In-Reply-To: <CACqU3MXysWUYNnNQniR5LB4x1UGhJqwoYnTFmj=U8do-qRghow@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/25/11 19:19, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Jul 25, 2011 at 9:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, 2011-07-25 at 21:08 -0400, Arnaud Lacombe wrote:
>>> Hi,
>>>
>>
>>> but the code generated seem to test %esi (`b', potentially
>>> uninitialized) before %ebx (`a'). Am I still missing something ?
>>
>> But it tests 'a' again afterward. If 'a' is 0, it doesn't matter what
>> 'b' was. So the uninitialized test is a wash. No harm done, except for
>> some wasted CPU cycles.
>>
> I see, even if `b' is junk, the final logic does not change.
Right.
Here's the .optimized dump I get for -Os:



<bb 2>:
  a_2 = e ();
  if (a_2 != 0B)
    goto <bb 3>;
  else
    goto <bb 4>;

<bb 3>:
  b_4 = f ();

<bb 4>:
  # b_1 = PHI <b_3(D)(2), b_4(3)>
  D.2708_5 = a_2 != 0B;
  D.2709_6 = b_1 != 0B;
  D.2710_7 = D.2709_6 & D.2708_5;
  if (D.2710_7 != 0)
    goto <bb 5>;
  else
    goto <bb 6>;

<bb 5>:
  g (); [tail call]

<bb 6>:
  return;

If we duplicate bb4 and isolate the paths leading out of bb2 we'd get
something like this:

<bb 2>:
  a_2 = e ();
  if (a_2 != 0B)
    goto <bb 3>;
  else
    goto <bb 7>;

<bb 3>:
  b_4 = f ();

<bb 4>:
  # b_1 = PHI  b_4(3)>
  D.2708_5 = a_2 != 0B;
  D.2709_6 = b_1 != 0B;
  D.2710_7 = D.2709_6 & D.2708_5;
  if (D.2710_7 != 0)
    goto <bb 5>;
  else
    goto <bb 6>;

<bb 5>:
  g (); [tail call]

<bb 6>:
  return;

<bb 7>:
  # b_1 = PHI <b_3(D)(2))>
  D.2708_5 = a_2 != 0B;
  D.2709_6 = b_1 != 0B;
  D.2710_7 = D.2709_6 & D.2708_5;
  if (D.2710_7 != 0)
    goto <bb 5>;
  else
    goto <bb 6>;


[I'm not going to fix all the SSA_NAMEs, I'm just showing roughly what
can be done with this code... ]

Then we can propagate the fact that a_2 == 0 into bb7 and a2 != 0 into
bb4.  That in turn allows bb7 to collapse into "goto bb6" and bb4
simplifies into if (b4 != 0) goto bb5 else goto bb6.  CFG
simplifications then eliminate the jump and combine bb3 & bb4 resulting in:




<bb 2>:
  a_2 = e ();
  if (a_2 != 0B)
    goto <bb 3>;
  else
    goto <bb 6>;

<bb 3>:
  b_4 = f ();
  if (b_4 != 0)
    goto <bb 5>;
  else
    goto <bb 6>;

<bb 5>:
  g (); [tail call]

<bb 6>:
  return;


Which just happens to be the code we get from -O2.  Unfortunately we
don't in general know when block duplication of this nature is going to
allow enough simplification to justify the possible code expansion.
Thus block duplication of this nature is severely limited when compiling
with -Os.

Jeff
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOLycMAAoJEBRtltQi2kC7wbQH/RO2vAAEoHFuJKapNewMcL39
Fm404+DxN1BWwt6HT1BQYfH9tpZCepAJzDVcVsYWFlDOabLUKos9Sju/O8qkSkWK
gYdZ/XbhntB+vNaEQEXz+DdDnbX1OCPCTwM5bjtJ6Gwkjk5W7fa+GHFo694UZ0fH
fgKpAuTVFaCGj94whReGmsNDe0CbpBYS9+Erx4uUsasfkyy5sLDwGaM7gEtg0VS/
ZMz2bP1RDslk3WVkitllO9msq7i70dlR8qw8UgaUSyyvpNrw0HcRxXoI9ZB82mm4
QCtrRD5S92gxdzTtJ0Jg6co+tS2NadDv4D4f9Fn1Ox2oE/oYWvKBvLgkI8Up2pk=
=5lTt
-----END PGP SIGNATURE-----
