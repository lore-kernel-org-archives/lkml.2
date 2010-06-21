Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0FUBGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:06:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:61097 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0FUBGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B6XmC0PpoMuSBVtUIQ0950qYd3Qk0/y1QwJJfMsaqoxJnT5PBmPfr4qSIHtXuSUwhs
         2zfFvqqIUA60tWCl/sQygEtis/tdKMA42dZSz9ICpvVRlubsocgYW3KBXrpoJQs0F1Mh
         JSyEQnmg16XQQp6Zc77PuwnJEQqprA4/8hMPY=
MIME-Version: 1.0
In-Reply-To: <4C165A8B.1060008@hp.com>
References: <AANLkTilW6Ym_vL02rVk4QFPIC3Dr0BC12oAxdjE9RXpf@mail.gmail.com>
	<4C07C927.4090901@hp.com>
	<AANLkTilGROAVnKE5odR6qy6LrVjPSHxkqCrPhAtHtjlQ@mail.gmail.com>
	<4C165A8B.1060008@hp.com>
Date: Sun, 20 Jun 2010 18:06:42 -0700
X-Google-Sender-Auth: lObL9Yg7Ru7uTRR4Eljr41pTrvQ
Message-ID: <AANLkTikUw2FWkkrgo-urKhrgdJTSJ0uvwJUr5b9Lwifz@mail.gmail.com>
Subject: Re: [PATCH 4/6] sctp multistream scheduling: extend socket API
From: Yaogong Wang <ywang15@ncsu.edu>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-sctp@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to keep the socket-based design but refine it to avoid
wasting resources on streams that are not negotiated. The modified
version will work as follow:

The choice and configuration of the scheduling algorithm is still
socket-based. Users are supposed to set this socket option after
declaring the socket but before association establishment. When the
socket option is set, the configurations are stored in sctp_sock.

In sctp_association_init, we don't immediate let the user-specified
scheduling algorithm take effect. Instead, the default FCFS is used.
The user-specified scheduling algorithm takes effect when the
association turn into ESTABLISHED state. At that point, we already
know how many stream are actually negotiated so that we can allocate
resources accordingly. Any remaining data chunks in the initial FCFS
queue will be moved to the new queue(s).

If the negotiated number of streams is smaller that what the user
requested, the scheduling algorithm should still work, but in a
truncated version. For example, suppose the user originally wants 4
streams and chooses weighted fair queue. The weight for stream 0, 1,
2, 3 are 1024, 1024, 2048, 2048 respectively. If only 3 streams are
negotiated in the end, WFQ will still be used but with 3 streams whose
weights are 1024, 1024, 2048.

Users are not supposed to change the scheduling algorithm on the fly.
If they do, in TCP-style socket, it won't take effect. The
configuration is only stored in sctp_sock but not in the association
or the outq. For UDP-style socket, changing scheduling configuration
on the fly will only affect new associations established after the
change. This simplifies the implementation and I think users typically
don't want to change the scheduling algorithm of an on-going
association.

Yaogong

On Mon, Jun 14, 2010 at 9:36 AM, Vlad Yasevich
<vladislav.yasevich@hp.com> wrote:
>
>
> Yaogong Wang wrote:
>
>> There is an important design issue here: when should the user set this
>> socket option?
>>
>> My current assumption is that the user choose the scheduling algorithm
>> after declaring the socket but before the establishment of any
>> association. Therefore, the granularity of control is socket-based
>> rather than association-based. In one-to-many style socket case, all
>> associations inherit the scheduling algorithm of the socket. The
>> problems with this approach are:
>> 1. Cannot specify different scheduling algorithm for each association
>> under the same socket
>> 2. Since the option is set before the establishment of any
>> association, it doesn't know how many streams would be negotiated. It
>> could only consult initmsg for the intended number of outgoing
>> streams.
>>
>> If we go with the association-based approach, the above problems can
>> be solved. But the question is: in this case, when should the user set
>> this option? In one-to-many style socket, associations are implicitly
>> established. There isn't a point where association is established but
>> data transfer hasn't started yet so that the user can choose the
>> scheduling algorithm. Any suggestion on this dilemma?
>
> I've been thinking about this and trying to come up with scenarios of
> when performing this function at association level may be useful.
>
> The most compelling example is really in a 1-1 or peeled off case.  Currently,
> one can not change the scheduling on a peeled off association and that
> might be a rather useful feature.  Typically, associations are peeled
> off just so that they can provide additional performance.  Such association
> may wants the additional benefit of stream prioritization.
>
> I can however see the issues on both side of this.  A good counter argument is
> that if a server should provide the same level of service for a given port.
> In the end, I think I'll leave it up to you.  My initial question was from the
> API perspective.
>
> Now there are some technical challenges in allowing per-association option.
> a)How do we deal with changing algorithms that require additional storage?
> b)What do we do with DATA that's been queued before algorithm is chosen?
> There may be others ones I haven't though off yet.
>
> The simplest answer to a) is that such operations are forbidden until the
> queue is drained.  That's the simplest to implement and may not be that
> bad for the application, considering we have a SENDER_DRY event that can
> allow the application to control when the call is made.
>
> As for b), we might have to go with a lobby or a 2 level queue approach.
> For this, we can probably re-use the socket send queue, that can be drained
> when association can send DATA.  This might be a good thing to have anyway
> so that we do not waste space for streams that haven't been negotiated.
>
> -vlad
>



-- 
========================
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
========================
