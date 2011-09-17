Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1IQSNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 14:13:22 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:24364 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1IQSNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 14:13:21 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz9371Kzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:173.226.105.130;KIP:(null);UIP:(null);IPVD:NLI;H:SF1EXCH1.PHS;RD:none;EFVD:NLI
From: Kent Hoxsey <khoxsey@paradigm-healthcare.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
Thread-Topic: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0
 Xen pv guest - BUG: Unable to handle]
Thread-Index: Acx1ZVv4DTvOUri9T7izYHJrX10ZBQ==
Date: Sat, 17 Sep 2011 18:12:28 +0000
Message-ID: <FD11FB67713F5F4CA0569B3F0468ED751A5CD2FF@SF1EXCH1.PHS>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: paradigm-healthcare.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am arriving to this discussion via a pointer on the Amazon AWS forums. There appear to be a number of threads with people experiencing some version of this issue (high IOwait%, httpd cpu load spike, etc.)

I currently have an AWS instance that appears to experience this problem every day at the same time (1:50pm Pacific), but has enough cpu horsepower to handle the surge and recover. Since it is a part of my production infrastructure, I cannot allow other people to log in, but I can certainly run diagnostics to help identify the issue. If anyone would like to suggest what diagnostics would be helpful I will try to collect them.

Kent
+++
As an example, following is a snip from mpstat during the load spike. Watching top at the same time, all of the httpd processes jump from 0.2% cpu to 15% or more, and then recover together once the spike passes:

08:49:31 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
...
08:49:46 PM  all    2.53    0.00    0.35    0.15    0.00    0.10    0.00    0.00   96.86
08:49:51 PM  all    3.63    0.00    0.52    0.16    0.00    0.10    0.05    0.00   95.53
08:49:56 PM  all    6.77    0.00    3.44    0.22    0.00    0.16    0.00    0.00   89.40
08:50:01 PM  all   53.19    0.00   41.04    0.00    0.00    0.30    5.48    0.00    0.00
08:50:06 PM  all   57.62    0.00   35.25    0.10    0.00    1.19    4.75    0.00    1.09
08:50:11 PM  all   34.85    0.00   19.09   43.20    0.00    0.77    0.46    0.00    1.62
08:50:16 PM  all   50.85    0.00   19.54   26.88    0.00    0.51    0.09    0.00    2.13
08:50:21 PM  all   31.87    0.00   16.87   49.18    0.00    0.45    0.07    0.00    1.57
08:50:26 PM  all   31.83    0.00   15.73   49.63    0.00    0.52    0.00    0.00    2.29
08:50:31 PM  all   30.50    0.00   16.91   51.03    0.00    0.30    0.07    0.00    1.18
08:50:36 PM  all   30.83    0.00   18.24   49.66    0.00    0.22    0.00    0.00    1.04
08:50:41 PM  all   33.58    0.00   15.86   48.47    0.00    0.22    0.07    0.00    1.79
08:50:46 PM  all   51.06    0.00   18.04   24.30    0.00    0.76    2.03    0.00    3.81
08:50:51 PM  all   69.61    0.00   23.73    0.39    0.00    0.39    4.22    0.00    1.67
08:50:56 PM  all   72.11    0.00   21.41    0.00    0.00    0.50    5.98    0.00    0.00
08:51:01 PM  all   71.84    0.00   21.44    0.10    0.00    0.59    5.43    0.00    0.59
08:51:06 PM  all   66.24    0.00   23.71    2.93    0.00    1.17    5.37    0.00    0.59
08:51:11 PM  all   67.97    0.00   22.66    1.95    0.00    0.68    5.27    0.00    1.46
08:51:16 PM  all   68.07    0.00   23.34    2.54    0.00    0.59    4.69    0.00    0.78
08:51:21 PM  all   55.47    0.00    8.56    2.80    0.00    0.25    1.98    0.00   30.95
08:51:26 PM  all   38.44    0.00    2.07    1.24    0.00    0.21    0.07    0.00   57.97
08:51:31 PM  all   12.65    0.00    1.85    0.87    0.00    0.40    0.00    0.00   84.23
08:51:36 PM  all    7.60    0.00    1.14   12.64    0.00    0.22    0.05    0.00   78.35
08:51:41 PM  all   10.29    0.00    0.99    0.12    0.00    0.29    0.00    0.00   88.31
08:51:46 PM  all    6.94    0.00    0.65    0.11    0.00    0.05    0.00    0.00   92.25
08:51:51 PM  all    7.05    0.00    0.86    0.43    0.00    0.11    0.05    0.00   91.49


