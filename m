Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1EXGVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:21:21 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:49581 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1EXGVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:21:20 -0400
Date: Tue, 24 May 2011 02:20:57 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306182141.2497.5.camel@laptop>
Message-ID: <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu> <1306182141.2497.5.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-513987991-1306218058=:28546"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-513987991-1306218058=:28546
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Mon, 23 May 2011, Peter Zijlstra wrote:

> > before the changeset, you could have a counter group where only one of the 
> > subevents was sampling.  PERF_EVENT_IOC_REFRESH would correctly enable 
> > sampling for only that subevent.
> 
> But how? it adds to the event_limit of the event you call the ioctl()
> on, not on any of the group siblings.

the old behavior did.

> > With the changeset applied, this fails with EINVALID.  Now you can only 
> > sample in a group leader.
> 
> I'm not quite seeing how group-leaders are relevant here, you can only
> call this ioctl() on sampling events, regardless of if they're they
> group leader or a sibling.

previous behavior was that if you called it on a group leader that wasn't 
sampling, a sibling event that was sampling would be activated.

> > Was this an intended change?  It breaks various of our PAPI regression 
> > tests that worked fine before the change was committed.
> 
> I'm not quite seeing what's wrong yet, the change seemed simple enough
> in that calling that ioctl() on an event that wasn't capable of
> generating samples doesn't make sense, since it will increase the event
> limit for the event you call it on.

attached is some code that will return a sampled count on older kernels
but gives EINVAL on current kernels.

The old behavior might have been unintentional, but PAPI unfortunately 
depends on it (not code I originaly wrote, but code I have to maintain).

Vince
--8323329-513987991-1306218058=:28546
Content-Type: TEXT/x-csrc; name=sampled_notleader_refresh.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1105240220570.28546@cl320.eecs.utk.edu>
Content-Description: 
Content-Disposition: attachment; filename=sampled_notleader_refresh.c

Lyogc2FtcGxlZF9ub3RsZWFkZXJfcmVmcmVzaC5jICAqLw0KLyogYnkgVmlu
Y2UgV2VhdmVyICAgdndlYXZlcjEgX2F0XyBlZWNzLnV0ay5lZHUgKi8NCg0K
LyogQ29tcGlsZSB3aXRoIGdjYyAtTzIgLVdhbGwgLW8gc2FtcGxlZF9ub3Rs
ZWFkZXJfcmVmcmVzaCBzYW1wbGVkX25vdGxlYWRlcl9yZWZyZXNoLmMgKi8N
Cg0KI2RlZmluZSBfR05VX1NPVVJDRSAxDQoNCiNpbmNsdWRlIDxzdGRpby5o
Pg0KI2luY2x1ZGUgPHN0ZGxpYi5oPg0KI2luY2x1ZGUgPHN0cmluZy5oPg0K
DQojaW5jbHVkZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8ZmNudGwuaD4NCg0K
I2luY2x1ZGUgPGVycm5vLmg+DQoNCiNpbmNsdWRlIDxzaWduYWwuaD4NCg0K
I2luY2x1ZGUgPHN5cy9tbWFuLmg+DQoNCiNpbmNsdWRlIDxzeXMvaW9jdGwu
aD4NCiNpbmNsdWRlIDxhc20vdW5pc3RkLmg+DQojaW5jbHVkZSA8c3lzL3By
Y3RsLmg+DQojaW5jbHVkZSA8bGludXgvcGVyZl9ldmVudC5oPg0KDQoNCg0K
c3RhdGljIGludCBjb3VudD0wOw0KDQpzdGF0aWMgdm9pZCBvdXJfaGFuZGxl
cihpbnQgc2lnbnVtLHNpZ2luZm9fdCAqb2gsIHZvaWQgKmJsYWgpIHsNCiAg
Y291bnQrKzsNCn0NCg0KaW50IHBlcmZfZXZlbnRfb3BlbihzdHJ1Y3QgcGVy
Zl9ldmVudF9hdHRyICpod19ldmVudF91cHRyLA0KCQkgICAgcGlkX3QgcGlk
LCBpbnQgY3B1LCBpbnQgZ3JvdXBfZmQsIHVuc2lnbmVkIGxvbmcgZmxhZ3Mp
IHsNCiANCiAgIHJldHVybiBzeXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVu
LCBod19ldmVudF91cHRyLCBwaWQsIGNwdSwgZ3JvdXBfZmQsZmxhZ3MpOw0K
fQ0KDQpkb3VibGUgYnVzeXdvcmsoaW50IGNvdW50KSB7DQogDQogICBpbnQg
aTsNCiAgIGRvdWJsZSBzdW09MC4wMDEyOw0KICAgDQogICBmb3IoaT0wO2k8
Y291bnQ7aSsrKSB7DQogICAgICBzdW0rPTAuMDE7DQogICB9DQogICByZXR1
cm4gc3VtOw0KICAgDQp9DQoNCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIq
KiBhcmd2KSB7DQogICANCiAgaW50IHJldCxmZDEsZmQyOyAgIA0KICBkb3Vi
bGUgcmVzdWx0Ow0KDQogICBzdHJ1Y3QgcGVyZl9ldmVudF9hdHRyIHBlOw0K
DQogICBzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KDQogICBtZW1zZXQoJnNhLCAw
LCBzaXplb2Yoc3RydWN0IHNpZ2FjdGlvbikpOw0KICAgc2Euc2Ffc2lnYWN0
aW9uID0gb3VyX2hhbmRsZXI7DQogICBzYS5zYV9mbGFncyA9IFNBX1NJR0lO
Rk87DQoNCiAgIGlmIChzaWdhY3Rpb24oIFNJR0lPLCAmc2EsIE5VTEwpIDwg
MCkgew0KICAgICBmcHJpbnRmKHN0ZGVyciwiRXJyb3Igc2V0dGluZyB1cCBz
aWduYWwgaGFuZGxlclxuIik7DQogICAgIGV4aXQoMSk7DQogICB9DQogICAN
CiAgIG1lbXNldCgmcGUsMCxzaXplb2Yoc3RydWN0IHBlcmZfZXZlbnRfYXR0
cikpOw0KDQogICBwZS50eXBlPVBFUkZfVFlQRV9IQVJEV0FSRTsNCiAgIHBl
LnNpemU9c2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIpOw0KICAgcGUu
Y29uZmlnPVBFUkZfQ09VTlRfSFdfSU5TVFJVQ1RJT05TOw0KICAgcGUuc2Ft
cGxlX3BlcmlvZD0wMDAwMDA7DQogICBwZS5zYW1wbGVfdHlwZT0wOw0KICAg
cGUucmVhZF9mb3JtYXQ9UEVSRl9GT1JNQVRfR1JPVVB8UEVSRl9GT1JNQVRf
SUQ7DQogICBwZS5kaXNhYmxlZD0xOw0KICAgcGUucGlubmVkPTA7DQogICBw
ZS5leGNsdWRlX2tlcm5lbD0xOw0KICAgcGUuZXhjbHVkZV9odj0xOw0KICAg
cGUud2FrZXVwX2V2ZW50cz0xOw0KDQogICBmZDE9cGVyZl9ldmVudF9vcGVu
KCZwZSwwLC0xLC0xLDApOw0KICAgaWYgKGZkMTwwKSB7DQogICAgICBmcHJp
bnRmKHN0ZGVyciwiRXJyb3Igb3BlbmluZyBsZWFkZXIgJWxseFxuIixwZS5j
b25maWcpOw0KICAgICAgZXhpdCgxKTsNCiAgIH0NCg0KICAgcGUudHlwZT1Q
RVJGX1RZUEVfSEFSRFdBUkU7DQogICBwZS5jb25maWc9UEVSRl9DT1VOVF9I
V19JTlNUUlVDVElPTlM7DQogICBwZS5zYW1wbGVfcGVyaW9kPTEwMDAwMDA7
DQogICBwZS5zYW1wbGVfdHlwZT1QRVJGX1NBTVBMRV9JUDsNCiAgIHBlLnJl
YWRfZm9ybWF0PVBFUkZfRk9STUFUX0dST1VQfFBFUkZfRk9STUFUX0lEOw0K
ICAgcGUuZGlzYWJsZWQ9MDsNCiAgIHBlLnBpbm5lZD0wOw0KICAgcGUuZXhj
bHVkZV9rZXJuZWw9MTsNCiAgIHBlLmV4Y2x1ZGVfaHY9MTsNCiAgIHBlLndh
a2V1cF9ldmVudHM9MTsNCg0KICAgZmQyPXBlcmZfZXZlbnRfb3BlbigmcGUs
MCwtMSxmZDEsMCk7DQogICBpZiAoZmQyPDApIHsNCiAgICAgIGZwcmludGYo
c3RkZXJyLCJFcnJvciBvcGVuaW5nICVsbHhcbiIscGUuY29uZmlnKTsNCiAg
ICAgIGV4aXQoMSk7DQogICB9DQoNCiAgIA0KICAgdm9pZCAqYmxhcmdoOw0K
ICAgDQogICAvKiBpbXBvcnRhbnQhICovDQogICBibGFyZ2g9bW1hcChOVUxM
LCAoMSsxKSo0MDk2LCANCiAgICAgICAgIFBST1RfUkVBRHxQUk9UX1dSSVRF
LCBNQVBfU0hBUkVELCBmZDIsIDApOw0KICAgDQogICBmY250bChmZDIsIEZf
U0VURkwsIE9fUkRXUnxPX05PTkJMT0NLfE9fQVNZTkMpOw0KICAgZmNudGwo
ZmQyLCBGX1NFVFNJRywgU0lHSU8pOw0KICAgZmNudGwoZmQyLEZfU0VUT1dO
LGdldHBpZCgpKTsNCiAgIA0KICAgaW9jdGwoZmQxLCBQRVJGX0VWRU5UX0lP
Q19SRVNFVCwgMCk7ICAgDQogICBpb2N0bChmZDIsIFBFUkZfRVZFTlRfSU9D
X1JFU0VULCAwKTsgICANCg0KICAgcmV0PWlvY3RsKGZkMSwgUEVSRl9FVkVO
VF9JT0NfUkVGUkVTSCwwKTsNCiAgICAgIGlmIChyZXQ8MCkgew0KICAgICBm
cHJpbnRmKHN0ZGVyciwiRXJyb3Igd2l0aCBQRVJGX0VWRU5UX0lPQ19SRUZS
RVNIIG9mIGdyb3VwIGxlYWRlcjogIg0KCSAgICAgIiVkICVzXG4iLGVycm5v
LHN0cmVycm9yKGVycm5vKSk7DQogICAgIGV4aXQoMSk7DQogICB9DQoNCiAg
IHJlc3VsdD1idXN5d29yaygxMDAwMDAwMCk7DQogICANCiAgIHJldD1pb2N0
bChmZDIsIFBFUkZfRVZFTlRfSU9DX0RJU0FCTEUsMCk7DQogICANCiAgIA0K
ICAgcHJpbnRmKCJDb3VudDogJWQgJWxmXG4iLGNvdW50LHJlc3VsdCk7DQoN
CiAgIA0KICAgcmV0dXJuIDA7DQp9DQoNCg==

--8323329-513987991-1306218058=:28546--
