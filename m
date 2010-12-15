Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0LOGmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:42:38 -0500
Received: from web120709.mail.ne1.yahoo.com ([98.138.82.216]:40904 "HELO
	web120709.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752661Ab0LOGmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:42:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=4LJHQnj/CxNww1eDfGHtYfihd/raSKbtbvDack42n7tFBWODoj/fXl0N76OhOPgKNvwO9a/jT+vcgZXJrQcmGOO07Frwq5F/UkZLdhODiGI4KyhqG61OKo5kTmkL8ZQ42A3j04DlJU2NmnldRtHRibXSeaNPJCka/Kye7bqcRh8=;
Message-ID: <294021.5068.qm@web120709.mail.ne1.yahoo.com>
X-YMail-OSG: WUdrQpMVM1m4Nqgy89Y0lA7Bk8oPDBleEgtW8qqQchbC5LO
 Np62psP8jEg1bRJZkZ4I0bkEb35GeNrJ.rMhe.v3C299QSNR5avuY4tPunr7
 CwzOnN5ku962.7ONtq1GVAI0SLHqzDlPtRJyuW8cY1iloVqgFwr4HEsACpiA
 tIV2qYxSqQrxTl4_xKh4pxbCmo6VIwYS33nkn5IuPRo.a_TJuQAnQmBiQGO3
 ZrHC79WQxa0lji5FgeQ--
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
Date: Tue, 14 Dec 2010 22:42:36 -0800 (PST)
From: Daniel Kopko <dk_fedorabugs@yahoo.com>
Subject: likely() vs. unlikely()
To: linux-kernel@vger.kernel.org
Cc: srostedt@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mr. Rostedt, LKML,

I've noticed the patch series by Steven Rostedt.  I am a bit of a lurker here, 
but I noticed something that I could perhaps contribute to.  Mr. Rostedt has 
done some great work deducing exactly whether or not these clauses meet their 
stated presumptions of "likeliness".  However, I think there may be some cases 
where accurately codifying branch biases based on literal likeliness might 
produce worse performance overall.  An example:

if(X)
    some_expensive_code();   //takes 500 ms
else
    some_very_cheap_code();  //takes 100 us

Now, let's say X is true 90% of the time.  The literal encoding of that would be 
"if(likely(X))".  However, it may make much more sense to encode it *wrongly* 
for the sake of cheapening the already cheap code, as the delay of the branch 
misprediction may be readily "absorbed" into the more expensive code.  In which 
case, even with X being likely, we may want to encode it as "if(unlikely(X))".  
(Also, to avoid obscuring things, please keep in mind that the bodies of the two 
halves of the branch above need not actually be function calls.)

I think that this type of thing may be most noticeable around any branches where 
there is a fastpath that may be run if ideal conditions are met, but which are 
met less than 50% of the time.  In such cases, the likely()/unlikely() may be 
used "wrongly" to cause the branch misprediction to occur in the 
already-high-latency (some_expensive_function()) case, and lower latencies in 
the already-low-latency (some_very_cheap_function()) case.  This would lead to 
lower attainable latencies overall (by at least the cost of a branch miss which 
would otherwise have been spent in the fast code), and further encourage coding 
to meet the ideal conditions of the fastpath.

So, several points:
1)  Please let me know if any of the above is outright wrong.
2)  I don't know if any such cases occur in the likely()/unlikely() patch 
series.  A place where it obviously DOESN'T occur would be:
http://marc.info/?l=linux-kernel&m=129229014528892&w=2
A place where I thought it MAY occur:
http://marc.info/?l=linux-kernel&m=129228728125413&w=2
3)  If there is overall agreement on the above, then I would also suggest that 
perhaps some additional macro names would be appropriate for the 
__builtin_expect() use (for cases where we want __builtin_expect(!!(X),1), but 
for which it isn't truly "likely", and for cases where we want 
__builtin_expect((X), 0), but for which it isn't truly "unlikely").  These would 
be parallel to likely()/unlikely() and have the same implementations, but 
different titles, to better document the intent of the code where they're used.  
Names maybe slow_branch_path() and fast_branch_path()? 
slow_branch()/fast_branch()?
4) I'm very sorry if this winds up ill-formatted.  I have a yahoo webmail 
client.  Open to suggestions for different free email providers on this front.


Thanks,

Daniel Kopko


      
