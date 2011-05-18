Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1ERW7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:59:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:18507 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1ERW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,233,1304319600"; 
   d="p7s'?scan'208";a="4267659"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Liu, Kent" <kent.liu@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
Date: Wed, 18 May 2011 23:58:57 +0100
Subject: Re: [PATCH v2] x86, vt-d: enable x2apic opt out
Thread-Topic: [PATCH v2] x86, vt-d: enable x2apic opt out
Thread-Index: AcwVrywLWBakNWAWTRSuzDnuwQRrnA==
Message-ID: <1305759537.28691.39.camel@i7.infradead.org>
References: <1302764783-24491-1-git-send-email-youquan.song@intel.com>
	 <1305126431.30435.163.camel@i7.infradead.org>
	 <1305577977.3146.112.camel@x201>
In-Reply-To: <1305577977.3146.112.camel@x201>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/signed; micalg=sha1;
	protocol="application/x-pkcs7-signature"; boundary="=-4W8CwHrqpNB86IqXF/pv"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-4W8CwHrqpNB86IqXF/pv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-05-16 at 21:32 +0100, Alex Williamson wrote:
>=20
> > Is this just a workaround for a crappy BIOS? What is the *actual* reaso=
n
> > for wanting to disable x2apic?
>=20
> Just a guess, but the OEM probably hasn't updated their SMI handlers to
> understand x2apic yet and won't before the product ships because some
> other OS doesn't bother to use x2apic.=20

But I think we'll still use x2apic if interrupt remapping isn't enabled
(for example if VT-d is disabled in the BIOS and the whole DMAR table is
absent), or if we're booted with 'iommu=3Doff' or indeed if the
distribution vendor has hacked the kernel so that iommu=3Doff is the
*default*, because they've seen so many broken BIOSes.

AFAICT although CONFIG_X86_X2APIC depends on CONFIG_INTR_REMAP, we can
still enable x2apic at runtime if interrupt remapping is not operating?
We end up hitting this code in enable_IR_x2apic():

	if (!ret) {
		/* IR is required if there is APIC ID > 255 even when running
		 * under KVM
		 */
		if (max_physical_apicid > 255 ||
		    !hypervisor_x2apic_available())
			goto nox2apic;
		/*
		 * without IR all CPUs can be addressed by IOAPIC/MSI
		 * only in physical mode
		 */
		x2apic_force_phys();
	}

So if that *is* the reason, this doesn't seem like a viable solution.

--=20
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-4W8CwHrqpNB86IqXF/pv
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIVTDCCAz0w
ggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UEChMHRXF1
aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTA2
MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUludGVs
IENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kgQ0EwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATDIsV2xDyt
30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUjZzTZFq2N
4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZvuSQ0E11y
YL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4lz36wOdN
Zn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+iC1HawJd
AgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0Vgaj7TdU
DDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3NlY3VyZWNh
LmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTADAQH/MA0G
CSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69tOkIP4Sg
DJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3jMfr900fX
ZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFijCCBHKgAwIBAgIKYR6AtwAAAAAABzAN
BgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24x
JzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUxOTI1MTNa
Fw0xNTA1MTUxOTM1MTNaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlv
bjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAMGPgGLnOO5IOzlHRfr1XfCVb97V4BR2QVpPZ7CrcIQ+FGa2
KHD/6dPjwxOIrtFTdfW4BYikdFmxUZVBWRWZ5Vye2cCdGzFWqIEOE1e17nNx1jM8Z6GZEqbDUS+v
BuPlBFHKQoVm5BaNIHpyn2XZxqwjV9j5/crIfPrCGstk+2ztUhVS8OHEgzO784PgD9pOgBnnAbZH
mEM1FYYmQ6ibS+gVCHzobDYG+YReRiHpFKWBxpUuP+X0WYFw/Ja1JW7N8pELAFDw0UFBWFgiv1QI
usdLvSy8mcsLJ5wy050OVcxShqoUxhw/wvyuuoQxvmEPjhRa1C2oSCmGN0003GMhQWMCAwEAAaOC
AlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFKoWZq+3PVZTYK4Nwu3z7gfLUWB+MAsG
A1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBTCKwhTx+hdMsKC
gOmWwLgjQsAV+TAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQaxgxKxEdv
qNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3LmludGVsLmNv
bS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBDQS5j
cmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIw
RXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYwgdMwYwYI
KwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0lu
dGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcwAoZgaHR0
cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQCU
Y/1d0MS6VPTlIcOho1XWh193PD5kJDJSPdphLHQdM1oKA+whMdIBoY1VzTDDK+C+Ey4Jcyna7fpC
8uVmn/Rz/i9MZtyc7qezPtZTn9UyORvJmddH+Ox/RycGwe3ags8jUdspECorYOkJyZksnDIlTVUv
bR7wyY+gGJYqxWXqrcVFEiMsWu8/OIlf7F2gAYMBw1kZ55dn4lWBIM0WqvReWpPvhYeN7Y+3MKEd
SMkQ7TZiNbfdZ5D/8KfWNMTJ4VHltOgCL1lA5tx/F4R1920skpL5eu3Sj650RUe3rOXsaV5NyJzB
wB31+1zsmleVdFD0k/Fw9HxXbAQE35ucN/7CMIIGFzCCBP+gAwIBAgIKEIhPUAABAABfaTANBgkq
hkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzAp
BgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0EwHhcNMTEwNDEyMTIzMzQx
WhcNMTQwMzI3MTIzMzQxWjBFMRkwFwYDVQQDExBXb29kaG91c2UsIERhdmlkMSgwJgYJKoZIhvcN
AQkBFhlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAvxW1JMLaZUeM6Cg2OVV1nfsZOt9x/CjVJ7SBlapefSjUoNT48n58zLK+Q00YxPkIxnwl
m57dAxSUf/Dqg+C6DOdLknVQILrGeWNSZdC8GQ8HlHz+D5ldgTDY9L1vDM65p1wbXW4R5QfMbooZ
IQKlyUivGkggwBUpTeeXDOfz5f4m2UW5aCnyG8yhiBUHISAQyXLwQg+iVhBpTqsVvvojybQY8lGF
Z7U+kgbgBY0HCqOuEmT7Iz/tm4W3dpfh8mFluZUn1fMBvCaC+cdKVV/1lpeUdtMNREH+jKUU49lt
BblH1qXmEViOvMT4itbfkUSWeWgeI9umMOK4eL31LLepCQIDAQABo4IC9jCCAvIwCwYDVR0PBAQD
AgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4HevTmV
8EMCAWQCAQgwHQYDVR0OBBYEFMcuq9ocKJ7EbWcVlAWTYVXwOsrHMB8GA1UdIwQYMBaAFKoWZq+3
PVZTYK4Nwu3z7gfLUWB+MIHPBgNVHR8EgccwgcQwgcGggb6ggbuGV2h0dHA6Ly93d3cuaW50ZWwu
Y29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBD
QSUyMDNBKDEpLmNybIZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9D
UkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0EoMSkuY3JsMIH1
BggrBgEFBQcBAQSB6DCB5TBsBggrBgEFBQcwAoZgaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwM0EoMSkuY3J0MHUGCCsGAQUFBzAChmlodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9y
ZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5n
JTIwQ0ElMjAzQSgxKS5jcnQwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBxLiiAAGnWEDYYtUaje48WjSbMx8O+TsKX2x1sgi/ilnUR
evhznvvFGx9hRrTtQ4Sz+hU7nWvoxbSLDVx6vDQ7+wyGo6SzE0MYqwB3EzwO/P8MnpgZTlEmgDeP
GjYX2IFzp5fG7NNvc6byf8pLjXgn+2wqRLUqrh2PZZ5KKIiicVNT+UOlRIbB2T1WuSVHBMQxhQBr
rzwwYuyoawJCHHo+eKUE51cSSzkT95K+m0Q6XYGC8tQ3i94nBIaLMIg/GM6K2cYKH3vdu/otvGPl
j9/HEKo+mktp2A2S5sIwCKlw8nYOaYKe1dpmYtXKfVoOIIZ/LaVEB/XEIEC1x/oPbrH/MIIGXjCC
BUagAwIBAgIKEI638AABAABfajANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UE
ChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3Vp
bmcgQ0EgM0EwHhcNMTEwNDEyMTI0MDM5WhcNMTQwMzI3MTI0MDM5WjBFMRkwFwYDVQQDExBXb29k
aG91c2UsIERhdmlkMSgwJgYJKoZIhvcNAQkBFhlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsm0RhbzQLRYFSlgFDKSsMvzFctyPQbT8P55g
gj3ZQuklaFo8CLXd3rODycyKauFT/IxEq8udUyanZXLSWdWQuuhrkG9bMnkDy1+KQSaEqgKPHMUT
1sYMyGFoDr4YDnmGLfpQWrBHUT+hwFuBUAqQRndQZbZK8TaOAX55hjNJEVWzXzaJNFb0ZFiaJ8Tl
SY+RA7NS0jv7gsCvV2LamrDZJ0Ht0YZLOenhDzVjph4dUY/2XFv2ceGZSUOyrMiVdkC7hpira+4e
CY5BKboFZluzg+URRnRd/EH08ilHzGxEaKheC99QVCgVl6qI0GguHnTReIU+QBN6D6Aj3kTbUZSw
ywIDAQABo4IDPTCCAzkwCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIbD
jHWEmeVRg/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgEMMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZI
hvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQU
anqVzAq92pn3diJlPhvbx6wENA0wHwYDVR0jBBgwFoAUqhZmr7c9VlNgrg3C7fPuB8tRYH4wgc8G
A1UdHwSBxzCBxDCBwaCBvqCBu4ZXaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0EoMSkuY3JshmBodHRw
Oi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcmwwgfUGCCsGAQUFBwEBBIHoMIHlMGwG
CCsGAQUFBzAChmBodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9J
bnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcnQwdQYIKwYB
BQUHMAKGaWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNBKDEpLmNydDAf
BgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUF
BwMEMAwGCisGAQQBgjcKAwQwTwYDVR0RBEgwRqApBgorBgEEAYI3FAIDoBsMGWRhdmlkLndvb2Ro
b3VzZUBpbnRlbC5jb22BGWRhdmlkLndvb2Rob3VzZUBpbnRlbC5jb20wDQYJKoZIhvcNAQEFBQAD
ggEBAIPoSUpUKiFzHvdhFZZAOQkn8UkNJu7E2TWKvlry/gpFf9Ra257sBA4s15nUGuS59M3bmnCe
n9C36IDHuQS3PQeY/DQ2lq26ZVZIiQScz/5hREJ1ZgvSlBJqwwdWEiy6BCKRInFpLfE7fMo3PmML
UcRaFDmYby1BcigEZP14fwa5kGZMOEJGicqeG76jftkAN03RXy0fQaTe2AdvSR/oAYbuY4hn6w8V
3XBcAxUHN9DIzgawtAnj5X5Lal9nOoq3jgAYGGL0upc5dEMNvygjFwzVVFnow1qaT8os8+UP/hla
Y33P2418t7KgL8M0AjtGOE1kUKZmGaV3ppkHI4ms9s4xggLYMIIC1AIBATBkMFYxCzAJBgNVBAYT
AlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSAzQQIKEIhPUAABAABfaTAJBgUrDgMCGgUAoIIBSTAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA1MTgyMjU4NTdaMCMGCSqGSIb3DQEJ
BDEWBBRcFO2DCEfiLdBloAvyIiIYXGb0QDBzBgkrBgEEAYI3EAQxZjBkMFYxCzAJBgNVBAYTAlVT
MRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFz
aWMgSXNzdWluZyBDQSAzQQIKEI638AABAABfajB1BgsqhkiG9w0BCRACCzFmoGQwVjELMAkGA1UE
BhMCVVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5h
bCBCYXNpYyBJc3N1aW5nIENBIDNBAgoQjrfwAAEAAF9qMA0GCSqGSIb3DQEBAQUABIIBAJ4xvV0N
2ZrcT3DyR7JgWqRP9gS6QWZKQl79rGXtTXihe4Z/JemgmRhwHAtQTxQ+r3QB37mKAiIbwLuDb1nL
NCEItnNPIxuPH+NuYu1GYjgzb7+nEeMZgX5zITf4G5xx93Tt/RvmkcHcJcBBXLk0Kf+/tseef+NS
GBpAcmv7tG4bpCLqUKvxNfwHgOlBBzYH7WWp97okcA16F9ELs5OdJizG2/2hsA+xwV2+X3HoK9I2
9mZKXP3Z3D+IwL9W0AOu2JI/huDoj7LMwXDTmvz246JwkeDiWvxAYE2c3vW8C3BhHiDBCtZq7muP
seKJ+TPB7Thsm+ojLnAysBJussZ8BVwAAAAAAAA=


--=-4W8CwHrqpNB86IqXF/pv--
